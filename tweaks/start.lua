require 'prelude'

local start = namespace 'tweaks.start'
start.enabled = true

function start.control()
    script.on_init(start.inventory)
end

function start.inventory()
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
        ["iron-stick"] = 20,
        ["iron-gear-wheel"] = 5,
        ["copper-cable"] = 20,
        ["copper-plate"] = 10,
        ["electronic-circuit"] = 5,
    })

    remote.call("freeplay", "set_debris_items", {
        ["steel-plate"] = 5,
    })
    
end

return start:__seal()