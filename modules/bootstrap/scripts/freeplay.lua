
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
        { name = "iron-plate",         count = 10 },
        { name = "pipe",               count = 10 },
        { name = "iron-gear-wheel",    count = 5  },
        { name = "copper-cable",       count = 20 },
        { name = "electronic-circuit", count = 5  },
    })

    remote.call("freeplay", "set_debris_items", {
        { name = "steel-plate",  count = 5  },
        { name = "iron-stick",   count = 20 },
        { name = "copper-plate", count = 10 },
    })

end

script.on_init(inventory)