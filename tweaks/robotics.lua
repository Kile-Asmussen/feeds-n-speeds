require 'prelude'

local robotics = namespace 'tweaks.robotics'

function robotics.data()
    data:extend(require 'tweaks.robotics.worker-robots-battery')
end

function robotics.data_updates()
    local roboports = data.raw.roboport

    roboports.roboport.charging_slots = 6

    if enabled('extras.roboports') then
        roboports[fns 'sleeper-roboport'].charging_slots = 8
        roboports[fns 'logistics-roboport'].charging_slots = 6
        roboports[fns 'construction-roboport'].charging_slots = 4
    else

    end

    for _, port in pairs(roboports) do
        port.charging_station_count_affected_by_quality = true
    end

    if enabled('tweaks.malltech', 'extras.roboports') then
        table.insert(data.raw.technology['robotics'].prerequisites, 'circuit-network')

        roboports[fns 'sleeper-roboport'].ingredients = {
            { type='item', name='roboport', amount=1 },
            { type='item', name='constant-combinator', amount=1 },
        }

        roboports[fns 'logistics-roboport'].ingredients = {
            { type='item', name='roboport', amount=1 },
            { type='item', name='arithmetic-combinator', amount=1 },
        }

        roboports[fns 'construction-roboport'].ingredients = {
            { type='item', name='roboport', amount=1 },
            { type='item', name='decider-combinator', amount=1 },
        }
    end

end

return robotics:__seal()