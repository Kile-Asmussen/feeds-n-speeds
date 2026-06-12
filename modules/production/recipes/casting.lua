--! data: new recipes for casting including recycling-like recipes for scrap metal
local fns = require 'fns'
local table = fns.table
local recipes = data.raw.recipe

recipes['casting-pipe'] = nil
recipes['casting-pipe-to-ground'] = nil
recipes['casting-low-density-structure'] = nil
fns.gadgets.remove_unlocks{'casting-pipe-to-ground', 'casting-low-density-structure', 'casting-pipe'}
data.raw.technology['low-density-structure-productivity'].effects = {
  {
    change = 0.1,
    recipe = "low-density-structure",
    type = "change-recipe-productivity"
  },
}

table.merge(recipes['casting-iron-stick'], {
    ingredients = {{ type='fluid', name='molten-iron', amount=10 }},
    results = {{ type='item', name='iron-stick', amount=2 }},
})
table.merge(recipes['casting-copper-cable'], {
    ingredients = {{ type='fluid', name='molten-copper', amount=10 }},
    results = {{ type='item', name='copper-cable', amount=2 }},
})

for _, r in ipairs{
    'casting-iron-gear-wheel',
    'casting-iron-stick',
    'casting-copper-cable',
} do
    recipes[r].energy_required = 1.6
end

for _, r in pairs(data.raw.recipe) do

end

data:extend{
    {
        type = 'recipe',
        name = fns 'casting-heat-pipe',
        allow_productivity = true,
        enabled = false,
        allow_auto_recycle = false,
        order = data.raw.item['heat-pipe'].order .. '-a[casting]',
        subgroup = data.raw.item['heat-pipe'].subgroup,
        auto_unlocked_by = 'foundry',
        icons = {
            {
                icon=data.raw.item['heat-pipe'].icon,
            },
            {
                icon='__space-age__/graphics/icons/fluid/molten-copper.png',
                scale=0.33,
                shift={-3, -6},
                floating=true,
            },
            {
                icon='__space-age__/graphics/icons/fluid/molten-iron.png',
                scale=0.33,
                shift={6, -6},
                floating=true,
            },
        },
        category = 'metallurgy',
        ingredients = {
            { type='fluid', name='molten-copper', amount=100 },
            { type='fluid', name='molten-iron', amount=60 },
        },
        energy_required = 8,
        results = {
            { type='item', name='heat-pipe', amount=1 }
        }
    }
}

local function melt_down(item, input, fluid, output)
    data.raw.item[item].allow_auto_recycle = false,
    data:extend{{
        type = 'recipe',
        name = fns ('melt-scrap-' .. item),
        enabled = false,
        allow_productivity = false,
        auto_unlocked_by = 'foundry',
        group = 'intermediate-products',
        localised_name = { fns.locale_key('recipe-name', 'melt-scrap'), {'item-name.' .. item} },
    
        icons = {
            {
                icon='__space-age__/graphics/icons/fluid/' .. fluid .. '.png',
                scale=0.33,
                shift={0, 0},
                floating=true,
            },
            {
                icon=data.raw.item[item].icon,
                scale=0.5,
            },
        },
        category = 'metallurgy',
        ingredients = {
            { type='item', name=item, amount=input },
        },
        energy_required = 6.4,
        results = {
            { type='fluid', name=fluid, amount=output }
        }
    }}
end

melt_down('iron-plate', 20, 'molten-iron', 50)
melt_down('iron-gear-wheel', 20, 'molten-iron', 50)
melt_down('copper-plate', 20, 'molten-copper', 50)
melt_down('pipe', 20, 'molten-iron', 50)
melt_down('steel-plate', 20, 'molten-iron', 150)
melt_down('barrel', 20, 'molten-iron', 150)
melt_down('iron-stick', 40, 'molten-iron', 50)
melt_down('copper-cable', 40, 'molten-copper', 50)

