require 'prelude'

local chests = namespace 'extras.chests'

chests.enabled = true

local function isvec(tbl)
    return #tbl == 2 and type(tbl[1]) == 'number' and type(tbl[2]) == 'number'
end

function chests.data()
    if not chests.enabled then return end

    local steel_chest = table.clone(data.raw.containers['steel-chest'])

    local function shift(t)
        if is_vec(t) then
            table.vecadd(t, { 0.35, 0.30 })
            return true
        end
        return false
    end

    table.traverse(steel_chest.circuit_connector, )

    local function double(t)
        if is_vec(t) then
            table.vecadd(t, 2)
            return true
        end
        return false
    end

    data:extend{
        require('extras.chests.big-steel-chest-building'),
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

return chests:__seal()