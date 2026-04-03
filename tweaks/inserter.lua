require 'prelude'

local inserter = namespace('tweaks.inserter')

inserter.toggle = 'feeds-n-speeds-tweaks-inserter-enable'
inserter.enabled = true

function inserter.data_updates()

    if not inserter.enabled then return end

    inserter = data.raw.inserter

    -- The red inserter is precisely half as fast as the fast inserter
    -- as well as twice as fast as the burner inserter
    -- This is not true of the yellow inserter, so let's fix that
    inserter.inserter.extension_speed = inserter['long-handed-inserter'].extension_speed
    inserter.inserter.rotation_speed = inserter['long-handed-inserter'].rotation_speed

    for inserter_name, inserter_data in pairs(inserter) do
        
        -- It's also annoying that inserters chase belts
        -- Also UPS heavy!
        inserter_data.chases_belt_items = false

        -- Let burner inserters leech
        if inserter_data.energy_source.type == 'burner' then
            inserter_data.allow_burner_leech = true
        end

        -- but downgrade upgrade slower inserters
        if inserter_data.rotation_speed <= inserter.inserter.rotation_speed then
            inserter_data.filter_slots = 2
        end
    end
end 

return inserter:__seal()