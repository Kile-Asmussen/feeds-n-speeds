require 'prelude'

local chests = namespace 'extras.chests'

chests.enabled = true

function chests.data()
    if not chests.enabled then return end

    chests.big_steel_chest_building()

    data:extend{
        -- require('extras.chests.big-steel-chest-building'),
        require('extras.chests.big-steel-chest-item'),
        require('extras.chests.big-steel-chest-recipe'),
        require('extras.chests.big-steel-chest-remnants'),
        require('extras.chests.big-steel-chest-explosion'),
    }
end

function chests.data_updates()

    if not chests.enabled then return end

    table.insert(data.raw.technology['steel-processing'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'big-steel-chest',
    })

end


function chests.big_steel_chest_building()
    local steel_chest = table.clone(data.raw.container['steel-chest'])
    
    table.traverse(steel_chest.circuit_connector,
        function(_, t)
            if table.isvec(t) then
                table.vecadd(t, { 0.35, 0.30 })
                return true
            end
            return false
        end
    )

    table.traverse(steel_chest,
        function(t, k)
            if k == 'circuit_connector' then
                return true
            end

            if table.isvec(t) then
                table.vecmul(t, 2)
                return true
            end

            if type(t) == 'table' and t.scale == 0.5 then
                t.scale = 1.0
            end

            return false
        end
    )

    table.traverse(steel_chest,
        function(t)
            if type(t) == 'string' and t:match("^steel%-chest") then
                return true, fns("big-" .. t)
            end
        end
    )

    steel_chest.max_health = steel_chest.max_health * 2
    steel_chest.inventory_size = steel_chest.inventory_size * 3
    steel_chest.minable.mining_time = 0.5

    data:extend{steel_chest}
end

return chests:__seal()