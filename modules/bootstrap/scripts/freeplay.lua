require 'prelude'

local function inventory()

    if not remote.interfaces["freeplay"] then return end

    local outfit = {
        ["pistol"] = 1,
        ["firearm-magazine"] = 10,
        ["shotgun"] = 1,
        ["shotgun-shell"] = 10,
        ['light-armor'] = 1,
    }

    remote.call("freeplay", "set_created_items", table.clone(outfit))
    remote.call("freeplay", "set_respawn_items", table.clone(outfit))

    remote.call("freeplay", "set_ship_items", {
        ["iron-plate"] = 10,
        ["pipe"] = 10,
        ["iron-gear-wheel"] = 5,
        ["copper-cable"] = 20,
        ["electronic-circuit"] = 5,
    })

    remote.call("freeplay", "set_debris_items", {
        ["steel-plate"] = 5,
        ["iron-stick"] = 20,
        ["copper-plate"] = 10,
    })

end

script.on_init(inventory)