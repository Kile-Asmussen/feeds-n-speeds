
local fns = require 'fns'

local function name(l) return fns('worker-robots-battery-' .. l) end

local function worker_robots_battery_tech(level, modifier, count, formula, time, cost, prereq)
    return {
        type = 'technology',
        name = name(level),
        upgrade = true,
        icons = {
            {
                icon = '__base__/graphics/technology/worker-robots-storage.png',
                icon_size = 256,
                tint = { 0.8, 1, 0.8 }
            },
            {
                floating = true,
                icon = '__core__/graphics/icons/technology/constants/constant-battery.png',
                icon_size = 128,
                scale = 0.5,
                shift = { 50, 50 }
            }
        },
        prerequisites = prereq,
        effects = {
            {
                type = "worker-robot-battery",
                modifier = modifier
            }
        },
        unit = {
            count = count,
            count_formula = formula,
            ingredients = table.collect(cost,
                function(s) return { s .. '-science-pack', 1 } end),
            time = time
        },
        max_level = level == 7 and 'infinite' or nil
    }
end

data:extend{
   worker_robots_battery_tech(1, 0.20, 50, nil, 30,
        {'automation', 'logistic', 'chemical'},
        {'robotics'}),
   worker_robots_battery_tech(2, 0.25, 100, nil, 30,
        {'automation', 'logistic', 'chemical'},
        { name(1) }),
   worker_robots_battery_tech(3, 0.25, 150, nil, 60,
        {'automation', 'logistic', 'chemical', 'production'},
        { name(2), 'production-science-pack'  }),
   worker_robots_battery_tech(4, 0.30, 250, nil, 60,
        {'automation', 'logistic', 'chemical', 'production'},
        { name(3) }),
   worker_robots_battery_tech(5, 0.30, 500, nil, 60,
        {'automation', 'logistic', 'chemical', 'production', 'utility'},
        { name(4), 'utility-science-pack' }),
   worker_robots_battery_tech(6, 0.30, 1000, nil, 60,
        {'automation', 'logistic', 'chemical', 'production', 'utility', 'space'},
        { name(5), 'space-science-pack' }),
    worker_robots_battery_tech(7, 0.35, nil, "2^(L-6) * 1000", 60,
        {'automation', 'logistic', 'chemical', 'production', 'utility', 'space', 'electromagnetic'},
        { name(6), 'electromagnetic-science-pack' }),
}