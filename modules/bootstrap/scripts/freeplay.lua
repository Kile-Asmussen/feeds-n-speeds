
local function outfit()
    return {
        ["pistol"] = 1,
        ["firearm-magazine"] = 10,
        ["shotgun"] = 1,
        ["shotgun-shell"] = 10,
        ['light-armor'] = 1,
    }
end

local function inventory()

    if not remote.interfaces["freeplay"] then return end

    remote.call("freeplay", "set_created_items", outfit())
    remote.call("freeplay", "set_respawn_items", outfit())

    remote.call("freeplay", "set_ship_items", {
        ["iron-plate"]         = 10,
        ["pipe"]               = 10,
        ["iron-gear-wheel"]    = 5,
        ["copper-cable"]       = 20,
        ["electronic-circuit"] = 5,
    })

    remote.call("freeplay", "set_debris_items", {
        ["steel-plate"]  = 5,
        ["iron-stick"]   = 20,
        ["copper-plate"] = 10,
        ["copper-cable"] = 10,
        ["iron-plate"] = 10,
        ["electronic-circuit"] = 10,
    })

end

script.on_init(inventory)