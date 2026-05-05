require 'prelude'

local chests = namespace 'extras.chests'
chests.enabled = true

function chests.data()
    if not chests.enabled then return end

    data:extend{
        require('extras.chests.big-steel-chest-building'),
        require('extras.chests.big-steel-chest-item'),
        require('extras.chests.big-steel-chest-recipe'),
        require('extras.chests.big-steel-chest-remnants'),
        require('extras.chests.big-steel-chest-explosion'),
        require('extras.chests.big-steel-hopper-building'),
        require('extras.chests.big-steel-hopper-item'),
        require('extras.chests.big-steel-hopper-recipe'),
    }
end

function chests.data_updates()

    local tech =  data.raw.technology

    if not enabled('tweaks.earlygame') then
        table.insert(tech['steel-processing'].effects, {
            type = 'unlock-recipe',
            recipe = fns 'big-steel-chest',
        })
    
        table.insert(tech['automation-2'].effects, {
            type = 'unlock-recipe',
            recipe = fns 'big-steel-hopper',
        })
    end
end

function chests.control()
    if not chests.enabled then return end

    script.on_init(chests.hopper.init_storage)

    script.on_load(chests.hopper.on_load)

    script.on_configuration_changed(chests.hopper.init_storage)

    script.on_event(defines.events.on_built_entity, chests.hopper.on_entity_built, chests.hopper.entity_filter)
    script.on_event(defines.events.on_robot_built_entity, chests.hopper.on_entity_built, chests.hopper.entity_filter)
    script.on_event(defines.events.script_raised_built, chests.hopper.on_entity_built)
    script.on_event(defines.events.script_raised_revive, chests.hopper.on_entity_built)

    script.on_event(defines.events.on_entity_died, chests.hopper.on_entity_destroyed, chests.hopper.entity_filter)
    script.on_event(defines.events.on_player_mined_entity, chests.hopper.on_entity_destroyed, chests.hopper.entity_filter)
    script.on_event(defines.events.on_robot_mined_entity, chests.hopper.on_entity_destroyed, chests.hopper.entity_filter)
    script.on_event(defines.events.script_raised_destroy, chests.hopper.on_entity_destroyed, chests.hopper.entity_filter)

end

chests.hopper = require 'extras.chests.hopper'

return seal_namespace(chests)