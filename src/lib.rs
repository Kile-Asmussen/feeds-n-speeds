// cSpell:ignore vec env Vec
use mlua::prelude::*;
use serde::de::Error;
use serde_json::{Map, Value};
use std::env::home_dir;
use std::path::PathBuf;
use std::{process, sync::Arc};

const DATA_RAW_DUMP: &str = ".factorio/script-output/data-raw-dump.json";
const MOD_LIST: &str = ".factorio/mods/mod-list.json";
const CORE_MODS: &[&str] = &["core", "base", "space-age", "quality", "elevated-rails"];

#[derive(serde::Serialize, serde::Deserialize, Clone, PartialEq, Eq, Debug, Hash)]
struct Mod {
    name: String,
    enabled: bool,
}

fn from_home(s: &str) -> PathBuf {
    let mut res = home_dir().unwrap();
    res.push(s);
    return res;
}

#[mlua::lua_module(name = "rawdata")]
fn rawdata(lua: &Lua) -> LuaResult<LuaTable> {
    if !std::fs::exists(from_home(DATA_RAW_DUMP)).map_err(lua_error)? {
        generate_data_raw()?
    }

    Ok(read_data_raw(lua)?)
}

fn lua_error<E: std::error::Error + 'static>(err: E) -> LuaError {
    LuaError::ExternalError(Arc::new(err))
}

fn read_mod_list() -> LuaResult<Vec<Mod>> {
    Ok(
        serde_json::from_slice(&std::fs::read(from_home(MOD_LIST)).map_err(lua_error)?)
            .map_err(lua_error)?,
    )
}

fn disable_mods(mods: &mut [Mod]) {
    for md in mods {
        md.enabled = CORE_MODS.contains(&&md.name[..]);
    }
}

fn write_mod_list(mods: &[Mod]) -> LuaResult<()> {
    std::fs::write(
        from_home(MOD_LIST),
        serde_json::to_vec_pretty(mods).map_err(lua_error)?,
    )
    .map_err(lua_error)?;
    Ok(())
}

fn factorio_dump_data_raw() -> LuaResult<()> {
    let mut proc = process::Command::new("steam")
        .args(["-launch", "427520", "--dump-data-raw"])
        .spawn()
        .map_err(lua_error)?;

    proc.wait().map_err(lua_error)?;

    return Ok(());
}

fn generate_data_raw() -> LuaResult<()> {
    let orig_modlist = if !std::fs::exists(from_home(MOD_LIST)).map_err(lua_error)? {
        vec![
            Mod {
                name: "base".to_string(),
                enabled: true,
            },
            Mod {
                name: "quality".to_string(),
                enabled: true,
            },
            Mod {
                name: "elevated-rails".to_string(),
                enabled: true,
            },
            Mod {
                name: "space-age".to_string(),
                enabled: true,
            },
        ]
    } else {
        read_mod_list()?
    };
    let mut new_modlist = orig_modlist.clone();
    disable_mods(&mut new_modlist);
    write_mod_list(&new_modlist)?;
    factorio_dump_data_raw()?;
    write_mod_list(&orig_modlist)?;
    Ok(())
}

fn read_data_raw(lua: &Lua) -> LuaResult<LuaTable> {
    let json = serde_json::from_slice::<Map<String, Value>>(
        &std::fs::read(from_home(DATA_RAW_DUMP)).map_err(lua_error)?,
    )
    .map_err(lua_error)?;

    let res = json_to_lua(lua, serde_json::Value::Object(json))?;

    if let LuaValue::Table(res) = res {
        return Ok(res);
    } else {
        return Err(lua_error(serde_json::Error::custom("Not an object")));
    }
}

fn json_to_lua(lua: &Lua, val: serde_json::Value) -> LuaResult<LuaValue> {
    Ok(match val {
        Value::Null => LuaValue::Nil,
        Value::Bool(b) => LuaValue::Boolean(b),
        Value::Number(n) => {
            if let Some(n) = n.as_i64() {
                LuaValue::Integer(n)
            } else if let Some(f) = n.as_f64() {
                LuaValue::Number(f)
            } else {
                LuaValue::Nil
            }
        }
        Value::String(s) => LuaValue::String(lua.create_string(&s)?),
        Value::Array(values) => LuaValue::Table(from_array(lua, values)?),
        Value::Object(map) => LuaValue::Table(from_map(lua, map)?),
    })
}

fn from_array(lua: &Lua, values: Vec<serde_json::Value>) -> LuaResult<LuaTable> {
    let res = lua.create_table()?;
    for v in values {
        res.push(json_to_lua(lua, v)?)?;
    }

    Ok(res)
}

fn from_map(lua: &Lua, map: serde_json::Map<String, serde_json::Value>) -> LuaResult<LuaTable> {
    let res = lua.create_table()?;
    for (k, v) in map {
        res.set(k, json_to_lua(lua, v)?)?;
    }

    Ok(res)
}
