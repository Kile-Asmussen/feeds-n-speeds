
local machines = namespace 'tweaks.machines'
machines.enabled = true

function machines.data2()
    if not machines.enabled then return end

    machines.tweak_assemblers()
    machines.tweak_inserters()
end

function machines.tweak_assemblers()
    local am1 = data.raw['assembling-machine']['assembling-machine-1']
    local am2 = data.raw['assembling-machine']['assembling-machine-2']

    am2.crafting_speed = 1.0

    local am3 = data.raw['assembling-machine']['assembling-machine-3']

    am3.crafting_speed = 1.5

    -- Replace the input fluid box with east-west through-flow connections
    am3.fluid_boxes[1].production_type = 'input'
    am3.fluid_boxes[1].pipe_connections = {
        {
            direction = 4,  -- east
            flow_direction = 'input-output',
            position = {1, 0},
        },
        {
            direction = 12,  -- west
            flow_direction = 'input-output',
            position = {-1, 0},
        },
    }
end

function machines.tweak_inserters()
    local inserters = data.raw.inserter

    inserters.inserter.extension_speed = 0.05
    inserters.inserter.rotation_speed = 0.03
    inserters.inserter.filter_slots = 3
    
    inserters['long-handed-inserter'].rotation_speed = 0.03
    inserters['long-handed-inserter'].extension_speed = 0.1

    inserters['fast-inserter'].rotation_speed = 0.05
    inserters['fast-inserter'].extension_speed = 0.1
    
    inserters['bulk-inserter'].rotation_speed = 0.05
    inserters['bulk-inserter'].extension_speed = 0.1

    inserters['stack-inserter'].rotation_speed = 0.05
    inserters['stack-inserter'].extension_speed = 0.1

    for inserter_name, inserter_data in pairs(inserters) do

        inserter_data.chases_belt_items = false

        if inserter_data.energy_source.type == 'burner' then
            inserter_data.allow_burner_leech = true
        end
    end
end

return seal_namespace(machines)