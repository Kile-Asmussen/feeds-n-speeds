use mlua::prelude::*;
use serde::de::Error;
use serde_json::{Map, Value};
use std::env::home_dir;
use std::path::PathBuf;
use std::time::{Duration, Instant};
use std::{process, sync::Arc};

const DUMP_POLL_INTERVAL: Duration = Duration::from_secs(2);
const DUMP_TIMEOUT: Duration = Duration::from_secs(120);

const MOD_LIST: &str = ".factorio/mods/mod-list.json";
const DUMP_CACHE_DIR: &str = ".factorio/script-output/rawdata-cache";
const BASE_MODS: &[&str] = &["base", "space-age", "quality", "elevated-rails"];

#[derive(serde::Serialize, serde::Deserialize, Clone, PartialEq, Eq, Debug, Hash)]
struct Mod {
    name: String,
    enabled: bool,
}

#[derive(serde::Serialize, serde::Deserialize)]
struct ModListFile {
    mods: Vec<Mod>,
}

fn from_home(s: &str) -> PathBuf {
    let mut res = home_dir().unwrap();
    res.push(s);
    res
}

fn lua_error<E: std::error::Error + 'static>(err: E) -> LuaError {
    LuaError::ExternalError(Arc::new(err))
}

fn read_mod_list_file() -> LuaResult<ModListFile> {
    Ok(
        serde_json::from_slice(&std::fs::read(from_home(MOD_LIST)).map_err(lua_error)?)
            .map_err(lua_error)?,
    )
}

fn write_mod_list_file(file: &ModListFile) -> LuaResult<()> {
    std::fs::write(
        from_home(MOD_LIST),
        serde_json::to_vec_pretty(file).map_err(lua_error)?,
    )
    .map_err(lua_error)?;
    Ok(())
}

fn full_mod_set(mod_names: &[String]) -> Vec<String> {
    let mut full: Vec<String> = BASE_MODS.iter().map(|s| s.to_string()).collect();
    for n in mod_names {
        if !BASE_MODS.contains(&&n[..]) {
            full.push(n.clone());
        }
    }
    full
}

fn cache_key(mod_names: &[String]) -> String {
    // base mods are implicit and excluded from the key
    let mut extra: Vec<&String> = mod_names
        .iter()
        .filter(|n| !BASE_MODS.contains(&&n[..]))
        .collect();
    extra.sort_unstable();
    if extra.is_empty() {
        "base".to_string()
    } else {
        extra.iter().map(|s| s.as_str()).collect::<Vec<_>>().join("+")
    }
}

fn cache_path(mod_names: &[String]) -> PathBuf {
    let mut path = from_home(DUMP_CACHE_DIR);
    path.push(format!("{}.json", cache_key(mod_names)));
    path
}

fn factorio_dump_data(mod_names: &[String]) -> LuaResult<()> {
    let orig = read_mod_list_file()?;
    let enabled = full_mod_set(mod_names);

    let new_mods: Vec<Mod> = orig
        .mods
        .iter()
        .map(|m| Mod {
            name: m.name.clone(),
            enabled: enabled.contains(&m.name),
        })
        .collect();

    // include any requested mods not already in the list
    let mut extra: Vec<Mod> = enabled
        .iter()
        .filter(|n| !orig.mods.iter().any(|m| &m.name == *n))
        .map(|n| Mod {
            name: n.clone(),
            enabled: true,
        })
        .collect();
    let mut combined = new_mods;
    combined.append(&mut extra);

    write_mod_list_file(&ModListFile { mods: combined })?;

    // delete any stale dump so we can detect when Factorio writes a fresh one
    let fixed = from_home(".factorio/script-output/data-raw-dump.json");
    let _ = std::fs::remove_file(&fixed);

    let mut steam = process::Command::new("steam")
        .args(["-applaunch", "427520", "--dump-data"])
        .spawn()
        .map_err(lua_error)?;

    // Steam exits quickly and hands off to Factorio; wait on it to clean up the handle.
    // Poll the dump file until its size is non-zero and stable across two consecutive
    // intervals, indicating Factorio has finished writing.
    let deadline = Instant::now() + DUMP_TIMEOUT;
    let mut last_size: Option<u64> = None;
    loop {
        if Instant::now() > deadline {
            let _ = steam.wait();
            write_mod_list_file(&orig)?;
            return Err(LuaError::RuntimeError(
                "timed out waiting for Factorio to write data-raw-dump.json".into(),
            ));
        }
        std::thread::sleep(DUMP_POLL_INTERVAL);
        let size = std::fs::metadata(&fixed).ok().map(|m| m.len());
        if let Some(sz) = size {
            if sz > 0 && last_size == size {
                break;
            }
        }
        last_size = size;
    }

    steam.wait().map_err(lua_error)?;
    write_mod_list_file(&orig)?;

    // move the dump into the cache
    let dest = cache_path(mod_names);
    std::fs::create_dir_all(dest.parent().unwrap()).map_err(lua_error)?;
    std::fs::rename(&fixed, &dest).map_err(lua_error)?;

    Ok(())
}

fn load_dump(lua: &Lua, mod_names: &[String]) -> LuaResult<LuaTable> {
    let path = cache_path(mod_names);
    let json =
        serde_json::from_slice::<Map<String, Value>>(&std::fs::read(&path).map_err(lua_error)?)
            .map_err(lua_error)?;

    match json_to_lua(lua, Value::Object(json))? {
        LuaValue::Table(t) => Ok(t),
        _ => Err(lua_error(serde_json::Error::custom(
            "root is not an object",
        ))),
    }
}

fn json_to_lua(lua: &Lua, val: Value) -> LuaResult<LuaValue> {
    Ok(match val {
        Value::Null => LuaValue::Nil,
        Value::Bool(b) => LuaValue::Boolean(b),
        Value::Number(n) => {
            if let Some(i) = n.as_i64() {
                LuaValue::Integer(i)
            } else if let Some(f) = n.as_f64() {
                LuaValue::Number(f)
            } else {
                LuaValue::Nil
            }
        }
        Value::String(s) => LuaValue::String(lua.create_string(&s)?),
        Value::Array(values) => {
            let t = lua.create_table()?;
            for v in values {
                t.push(json_to_lua(lua, v)?)?;
            }
            LuaValue::Table(t)
        }
        Value::Object(map) => {
            let t = lua.create_table()?;
            for (k, v) in map {
                t.set(k, json_to_lua(lua, v)?)?;
            }
            LuaValue::Table(t)
        }
    })
}

fn mod_names_from_lua(mods: LuaTable) -> LuaResult<Vec<String>> {
    mods.sequence_values::<String>().collect()
}

#[mlua::lua_module(name = "test_rawdata")]
fn test_rawdata(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;

    // mod_list() -> [{name=string, enabled=bool}]
    exports.set(
        "mod_list",
        lua.create_function(|lua, ()| {
            let file = read_mod_list_file()?;
            let t = lua.create_table()?;
            for m in file.mods {
                let entry = lua.create_table()?;
                entry.set("name", m.name)?;
                entry.set("enabled", m.enabled)?;
                t.push(entry)?;
            }
            Ok(t)
        })?,
    )?;

    // dump(mod_names: [string]) -- runs Factorio, caches result; blocks until done
    exports.set(
        "dump",
        lua.create_function(|_lua, mods: LuaTable| {
            let names = mod_names_from_lua(mods)?;
            factorio_dump_data(&names)
        })?,
    )?;

    // load(mod_names: [string]) -> data.raw table
    // dumps first if cache is missing
    exports.set(
        "load",
        lua.create_function(|lua, mods: LuaTable| {
            let names = mod_names_from_lua(mods)?;
            if !cache_path(&names).exists() {
                factorio_dump_data(&names)?;
            }
            load_dump(lua, &names)
        })?,
    )?;

    Ok(exports)
}
