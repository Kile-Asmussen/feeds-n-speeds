require('utils')

tweaks = tweaks or {}
tweaks.inserter = tweaks.inserter or {}


function tweaks.inserter.data_update()

    inserter = data.raw.inserter

    -- The red inserter is precisely half as fast as the fast inserter
    -- as well as twice as fast as the burner inserter

    -- This is not true of the yellow inserter, so let's fix that
    inserter.inserter.extension_speed = inserter['long-handed-inserter'].extension_speed
    inserter.inserter.rotation_speed = inserter['long-handed-inserter'].rotation_speed

    -- It's also annoying that inserters chase belts
    for inserter_name, inserter_data in pairs(data.raw.inserter) do
        inserter_data.chases_belt_items = false
    end
end 
