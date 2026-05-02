require 'prelude'

local start = namespace 'tweaks.start'
start.enabled = true

function start.control()
    script.on_init(start.inventory)
    script.on_load(start.fix_technologies)
end

function start.fix_technologies()
    -- TODO
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

return start:__seal()