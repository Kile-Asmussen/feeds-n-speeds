require 'prelude'

local machines = namespace 'tweaks.machines'
machines.enabled = true

function machines.data_updates()
    if not machines.enabled then return end

    machines.tweak_assemblers()
    machines.tweak_inserters()
end

function machines.tweak_assemblers()
    local am3 = data.raw['assembling-machine']['assembling-machine-3']

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

    -- The red inserter is precisely half as fast as the fast inserter
    -- as well as twice as fast as the burner inserter
    -- This is not true of the yellow inserter, so let's fix that
    inserters.inserter.extension_speed = inserters['long-handed-inserter'].extension_speed
    inserters.inserter.rotation_speed = inserters['long-handed-inserter'].rotation_speed

    for inserter_name, inserter_data in pairs(inserters) do

        -- It's also annoying that inserters chase belts
        -- Also UPS heavy!
        inserter_data.chases_belt_items = false

        -- Let burner inserters leech
        if inserter_data.energy_source.type == 'burner' then
            inserter_data.allow_burner_leech = true
        end

        -- but downgrade upgrade slower inserters
        if inserter_data.rotation_speed <= inserters.inserter.rotation_speed then
            inserter_data.filter_slots = 2
        end
    end
end

return machines:__seal()