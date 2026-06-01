use mlua::prelude::*;

// Implements string.pack, string.unpack, string.packsize per Lua 5.4 §6.4.2.
//
// Format strings start as "!1=" — max alignment 1 (no alignment), native endian.
//
// Option codes:
//   < > =       endianness (little, big, native)
//   ![n]        set max alignment to n (default: native = NATIVE_INT_SIZE)
//   b B         signed/unsigned 8-bit
//   h H         signed/unsigned short (NATIVE_SHORT_SIZE)
//   l L         signed/unsigned long (NATIVE_LONG_SIZE)
//   j J         lua_Integer / lua_Unsigned (NATIVE_INT_SIZE)
//   T           size_t (NATIVE_INT_SIZE)
//   i[n] I[n]   signed/unsigned n-byte int (default 4; n in 1..=16)
//   f           float (4 bytes)
//   d n         double / lua_Number (8 bytes)
//   cn          fixed string of n bytes (no alignment)
//   z           null-terminated string (no alignment)
//   s[n]        length-prefixed string; length is n-byte uint (default size_t)
//   x           1 byte of padding
//   Xop         align to op's alignment (op is otherwise ignored)
//   ' '         ignored

const MAX_INT_SIZE: usize = 16;
const NATIVE_INT_SIZE: usize = 8;   // lua_Integer / size_t on 64-bit
const NATIVE_SHORT_SIZE: usize = 2; // short on x86-64
const NATIVE_LONG_SIZE: usize = 8;  // long on x86-64 Linux

#[derive(Clone, Copy)]
enum Endian { Little, Big, Native }

impl Endian {
    fn is_little(self) -> bool {
        match self {
            Endian::Little => true,
            Endian::Big => false,
            Endian::Native => cfg!(target_endian = "little"),
        }
    }
}

struct Fmt<'a> {
    bytes: &'a [u8],
    pos: usize,
    endian: Endian,
    max_align: usize,
}

impl<'a> Fmt<'a> {
    fn new(s: &'a str) -> Self {
        Fmt { bytes: s.as_bytes(), pos: 0, endian: Endian::Native, max_align: 1 }
    }

    fn next(&mut self) -> Option<u8> {
        let c = self.bytes.get(self.pos).copied();
        if c.is_some() { self.pos += 1; }
        c
    }

    fn read_num(&mut self) -> Option<usize> {
        let start = self.pos;
        while self.bytes.get(self.pos).map_or(false, |c| c.is_ascii_digit()) {
            self.pos += 1;
        }
        if self.pos > start {
            std::str::from_utf8(&self.bytes[start..self.pos]).ok()?.parse().ok()
        } else {
            None
        }
    }

    fn align_of(&self, size: usize) -> usize {
        size.min(self.max_align)
    }

    fn native_size_of(&self, c: u8, explicit: Option<usize>) -> LuaResult<usize> {
        Ok(match c {
            b'b' | b'B' => 1,
            b'h' | b'H' => NATIVE_SHORT_SIZE,
            b'l' | b'L' => NATIVE_LONG_SIZE,
            b'j' | b'J' | b'T' => NATIVE_INT_SIZE,
            b'f' => 4,
            b'd' | b'n' => 8,
            b'i' | b'I' => explicit.unwrap_or(4),
            b's' => explicit.unwrap_or(NATIVE_INT_SIZE),
            _ => return Err(LuaError::RuntimeError(
                format!("invalid format option '{}'", c as char)
            )),
        })
    }
}

fn align_up(n: usize, align: usize) -> usize {
    if align <= 1 { n } else { (n + align - 1) & !(align - 1) }
}

fn pack_uint(buf: &mut Vec<u8>, val: u64, size: usize, little: bool) {
    let bytes: Vec<u8> = (0..size).map(|i| ((val >> (i * 8)) & 0xff) as u8).collect();
    if little { buf.extend_from_slice(&bytes); } else { buf.extend(bytes.into_iter().rev()); }
}

fn unpack_uint(data: &[u8], size: usize, little: bool) -> u64 {
    let mut val: u64 = 0;
    if little {
        for i in 0..size { val |= (data[i] as u64) << (i * 8); }
    } else {
        for i in 0..size { val = (val << 8) | (data[i] as u64); }
    }
    val
}

fn sign_extend(val: u64, size: usize) -> i64 {
    if size >= 8 { return val as i64; }
    let sign_bit = 1u64 << (size * 8 - 1);
    if val & sign_bit != 0 { (val | !((sign_bit << 1).wrapping_sub(1))) as i64 } else { val as i64 }
}

pub fn string_pack(lua: &Lua, (fmt, args): (String, LuaMultiValue)) -> LuaResult<LuaString> {
    let mut f = Fmt::new(&fmt);
    let mut buf: Vec<u8> = Vec::new();
    let args: Vec<LuaValue> = args.into_iter().collect();
    let mut ai = 0usize;

    macro_rules! int_arg {
        () => {{
            match args.get(ai) {
                Some(LuaValue::Integer(i)) => { ai += 1; Ok(*i) }
                Some(LuaValue::Number(n)) => { ai += 1; Ok(*n as i64) }
                Some(_) => Err(LuaError::RuntimeError("pack: expected integer".into())),
                None => Err(LuaError::RuntimeError(format!("bad argument #{} (value expected)", ai + 2))),
            }
        }};
    }
    macro_rules! float_arg {
        () => {{
            match args.get(ai) {
                Some(LuaValue::Number(n)) => { ai += 1; Ok(*n) }
                Some(LuaValue::Integer(i)) => { ai += 1; Ok(*i as f64) }
                Some(_) => Err(LuaError::RuntimeError("pack: expected number".into())),
                None => Err(LuaError::RuntimeError(format!("bad argument #{} (value expected)", ai + 2))),
            }
        }};
    }
    macro_rules! str_arg {
        () => {{
            match args.get(ai) {
                Some(LuaValue::String(s)) => { ai += 1; Ok(s.as_bytes().to_vec()) }
                Some(_) => Err(LuaError::RuntimeError("pack: expected string".into())),
                None => Err(LuaError::RuntimeError(format!("bad argument #{} (value expected)", ai + 2))),
            }
        }};
    }

    while let Some(c) = f.next() {
        match c {
            b'<' => { f.endian = Endian::Little; continue; }
            b'>' => { f.endian = Endian::Big; continue; }
            b'=' => { f.endian = Endian::Native; continue; }
            b'!' => { f.max_align = f.read_num().unwrap_or(NATIVE_INT_SIZE); continue; }
            b' ' => continue,
            _ => {}
        }
        let little = f.endian.is_little();
        match c {
            b'b' | b'B' => {
                let v = int_arg!()?;
                buf.resize(align_up(buf.len(), f.align_of(1)), 0);
                pack_uint(&mut buf, v as u64, 1, little);
            }
            b'h' | b'H' => {
                let v = int_arg!()?;
                let sz = NATIVE_SHORT_SIZE;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                pack_uint(&mut buf, v as u64, sz, little);
            }
            b'l' | b'L' => {
                let v = int_arg!()?;
                let sz = NATIVE_LONG_SIZE;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                pack_uint(&mut buf, v as u64, sz, little);
            }
            b'j' | b'J' | b'T' => {
                let v = int_arg!()?;
                let sz = NATIVE_INT_SIZE;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                pack_uint(&mut buf, v as u64, sz, little);
            }
            b'i' | b'I' => {
                let sz = f.read_num().unwrap_or(4);
                if sz == 0 || sz > MAX_INT_SIZE {
                    return Err(LuaError::RuntimeError(format!("integral size ({sz}) out of limits [1,{MAX_INT_SIZE}]")));
                }
                let v = int_arg!()?;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                pack_uint(&mut buf, v as u64, sz, little);
            }
            b'f' => {
                let v = float_arg!()? as f32;
                let sz = 4;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                let bytes = if little { v.to_le_bytes() } else { v.to_be_bytes() };
                buf.extend_from_slice(&bytes);
            }
            b'd' | b'n' => {
                let v = float_arg!()?;
                let sz = 8;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                let bytes = if little { v.to_le_bytes() } else { v.to_be_bytes() };
                buf.extend_from_slice(&bytes);
            }
            b'c' => {
                let n = f.read_num().ok_or_else(|| LuaError::RuntimeError("missing size for 'c'".into()))?;
                let s = str_arg!()?;
                // 'c' and 'z' are not aligned
                let written = s.len().min(n);
                buf.extend_from_slice(&s[..written]);
                buf.resize(buf.len() + (n - written), 0);
            }
            b'z' => {
                let s = str_arg!()?;
                if s.contains(&0u8) {
                    return Err(LuaError::RuntimeError("pack 'z': string contains NUL".into()));
                }
                buf.extend_from_slice(&s);
                buf.push(0);
            }
            b's' => {
                let sz = f.read_num().unwrap_or(NATIVE_INT_SIZE);
                if sz == 0 || sz > MAX_INT_SIZE {
                    return Err(LuaError::RuntimeError(format!("integral size ({sz}) out of limits")));
                }
                let s = str_arg!()?;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
                pack_uint(&mut buf, s.len() as u64, sz, little);
                buf.extend_from_slice(&s);
            }
            b'x' => { buf.push(0); }
            b'X' => {
                // Xop: align to op's alignment; op is consumed but otherwise ignored
                let op = f.next().ok_or_else(|| LuaError::RuntimeError("'X' missing option".into()))?;
                let explicit = f.read_num();
                let sz = f.native_size_of(op, explicit)?;
                buf.resize(align_up(buf.len(), f.align_of(sz)), 0);
            }
            other => return Err(LuaError::RuntimeError(format!("invalid format option '{}'", other as char))),
        }
    }

    lua.create_string(&buf)
}

pub fn string_packsize(_lua: &Lua, (fmt,): (String,)) -> LuaResult<i64> {
    let mut f = Fmt::new(&fmt);
    let mut size: usize = 0;

    while let Some(c) = f.next() {
        match c {
            b'<' => { f.endian = Endian::Little; continue; }
            b'>' => { f.endian = Endian::Big; continue; }
            b'=' => { f.endian = Endian::Native; continue; }
            b'!' => { f.max_align = f.read_num().unwrap_or(NATIVE_INT_SIZE); continue; }
            b' ' => continue,
            _ => {}
        }
        match c {
            b'b' | b'B' => { size = align_up(size, f.align_of(1)) + 1; }
            b'h' | b'H' => { size = align_up(size, f.align_of(NATIVE_SHORT_SIZE)) + NATIVE_SHORT_SIZE; }
            b'l' | b'L' => { size = align_up(size, f.align_of(NATIVE_LONG_SIZE)) + NATIVE_LONG_SIZE; }
            b'j' | b'J' | b'T' => { size = align_up(size, f.align_of(NATIVE_INT_SIZE)) + NATIVE_INT_SIZE; }
            b'f' => { size = align_up(size, f.align_of(4)) + 4; }
            b'd' | b'n' => { size = align_up(size, f.align_of(8)) + 8; }
            b'i' | b'I' => {
                let sz = f.read_num().unwrap_or(4);
                if sz == 0 || sz > MAX_INT_SIZE {
                    return Err(LuaError::RuntimeError(format!("integral size ({sz}) out of limits")));
                }
                size = align_up(size, f.align_of(sz)) + sz;
            }
            b'c' => {
                let n = f.read_num().ok_or_else(|| LuaError::RuntimeError("missing size for 'c'".into()))?;
                size += n;
            }
            b'x' => { size += 1; }
            b'X' => {
                let op = f.next().ok_or_else(|| LuaError::RuntimeError("'X' missing option".into()))?;
                let explicit = f.read_num();
                let sz = f.native_size_of(op, explicit)?;
                size = align_up(size, f.align_of(sz));
            }
            b'z' | b's' => {
                return Err(LuaError::RuntimeError("packsize: 'z'/'s' have variable size".into()));
            }
            other => return Err(LuaError::RuntimeError(format!("invalid format option '{}'", other as char))),
        }
    }

    Ok(size as i64)
}

pub fn string_unpack(lua: &Lua, (fmt, s, init): (String, LuaString, Option<i64>)) -> LuaResult<LuaMultiValue> {
    let data = s.as_bytes();
    let mut pos: usize = match init.unwrap_or(1) {
        i if i > 0 => (i - 1) as usize,
        i => (data.len() as i64 + i) as usize,
    };

    let mut f = Fmt::new(&fmt);
    let mut results: Vec<LuaValue> = Vec::new();

    macro_rules! need {
        ($n:expr) => {
            if pos + $n > data.len() {
                return Err(LuaError::RuntimeError("data string too short".into()));
            }
        };
    }

    while let Some(c) = f.next() {
        match c {
            b'<' => { f.endian = Endian::Little; continue; }
            b'>' => { f.endian = Endian::Big; continue; }
            b'=' => { f.endian = Endian::Native; continue; }
            b'!' => { f.max_align = f.read_num().unwrap_or(NATIVE_INT_SIZE); continue; }
            b' ' => continue,
            _ => {}
        }
        let little = f.endian.is_little();

        match c {
            b'b' => {
                pos = align_up(pos, f.align_of(1)); need!(1);
                results.push(LuaValue::Integer(sign_extend(unpack_uint(&data[pos..], 1, little), 1)));
                pos += 1;
            }
            b'B' => {
                pos = align_up(pos, f.align_of(1)); need!(1);
                results.push(LuaValue::Integer(unpack_uint(&data[pos..], 1, little) as i64));
                pos += 1;
            }
            b'h' => {
                let sz = NATIVE_SHORT_SIZE;
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                results.push(LuaValue::Integer(sign_extend(unpack_uint(&data[pos..], sz, little), sz)));
                pos += sz;
            }
            b'H' => {
                let sz = NATIVE_SHORT_SIZE;
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                results.push(LuaValue::Integer(unpack_uint(&data[pos..], sz, little) as i64));
                pos += sz;
            }
            b'l' | b'j' => {
                let sz = if c == b'l' { NATIVE_LONG_SIZE } else { NATIVE_INT_SIZE };
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                results.push(LuaValue::Integer(sign_extend(unpack_uint(&data[pos..], sz, little), sz)));
                pos += sz;
            }
            b'L' | b'J' | b'T' => {
                let sz = if c == b'L' { NATIVE_LONG_SIZE } else { NATIVE_INT_SIZE };
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                results.push(LuaValue::Integer(unpack_uint(&data[pos..], sz, little) as i64));
                pos += sz;
            }
            b'i' => {
                let sz = f.read_num().unwrap_or(4);
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                results.push(LuaValue::Integer(sign_extend(unpack_uint(&data[pos..], sz, little), sz)));
                pos += sz;
            }
            b'I' => {
                let sz = f.read_num().unwrap_or(4);
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                results.push(LuaValue::Integer(unpack_uint(&data[pos..], sz, little) as i64));
                pos += sz;
            }
            b'f' => {
                let sz = 4; pos = align_up(pos, f.align_of(sz)); need!(sz);
                let bytes: [u8; 4] = data[pos..pos+4].try_into().unwrap();
                results.push(LuaValue::Number(if little { f32::from_le_bytes(bytes) } else { f32::from_be_bytes(bytes) } as f64));
                pos += sz;
            }
            b'd' | b'n' => {
                let sz = 8; pos = align_up(pos, f.align_of(sz)); need!(sz);
                let bytes: [u8; 8] = data[pos..pos+8].try_into().unwrap();
                results.push(LuaValue::Number(if little { f64::from_le_bytes(bytes) } else { f64::from_be_bytes(bytes) }));
                pos += sz;
            }
            b'c' => {
                let n = f.read_num().ok_or_else(|| LuaError::RuntimeError("missing size for 'c'".into()))?;
                need!(n);
                results.push(LuaValue::String(lua.create_string(&data[pos..pos+n])?));
                pos += n;
            }
            b'z' => {
                let end = data[pos..].iter().position(|&b| b == 0)
                    .ok_or_else(|| LuaError::RuntimeError("unpack 'z': missing NUL".into()))?;
                results.push(LuaValue::String(lua.create_string(&data[pos..pos+end])?));
                pos += end + 1;
            }
            b's' => {
                let sz = f.read_num().unwrap_or(NATIVE_INT_SIZE);
                pos = align_up(pos, f.align_of(sz)); need!(sz);
                let len = unpack_uint(&data[pos..], sz, little) as usize;
                pos += sz;
                need!(len);
                results.push(LuaValue::String(lua.create_string(&data[pos..pos+len])?));
                pos += len;
            }
            b'x' => { need!(1); pos += 1; }
            b'X' => {
                let op = f.next().ok_or_else(|| LuaError::RuntimeError("'X' missing option".into()))?;
                let explicit = f.read_num();
                let sz = f.native_size_of(op, explicit)?;
                pos = align_up(pos, f.align_of(sz));
            }
            other => return Err(LuaError::RuntimeError(format!("invalid format option '{}'", other as char))),
        }
    }

    // unpack always appends the next-position (1-based) as the final return value
    results.push(LuaValue::Integer((pos + 1) as i64));
    Ok(LuaMultiValue::from_vec(results))
}

pub fn register(lua: &Lua, exports: &LuaTable) -> LuaResult<()> {
    let string_lib: LuaTable = lua.globals().get("string")?;
    string_lib.set("pack",     lua.create_function(string_pack)?)?;
    string_lib.set("unpack",   lua.create_function(string_unpack)?)?;
    string_lib.set("packsize", lua.create_function(string_packsize)?)?;
    exports.set("register_string_pack", lua.create_function(|lua, ()| {
        let string_lib: LuaTable = lua.globals().get("string")?;
        string_lib.set("pack",     lua.create_function(string_pack)?)?;
        string_lib.set("unpack",   lua.create_function(string_unpack)?)?;
        string_lib.set("packsize", lua.create_function(string_packsize)?)?;
        Ok(())
    })?)?;
    Ok(())
}
