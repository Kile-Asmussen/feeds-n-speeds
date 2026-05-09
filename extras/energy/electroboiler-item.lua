require 'prelude'

local name = fns 'electroboiler'

return {
    type = 'item',
    name = name,
    icons = {
        {
            icon = '__base__/graphics/icons/boiler.png',
            icon_size = 64,
            scale = 0.5
        },
        {
            icon = '__base__/graphics/icons/signal/signal-lightning.png',
            floating = true,
            icon_size = 64,
            scale = 0.33,
            shift = { -6, 6 },
            tint = { r = 0, g = 1, b = 0 },
        }
    },
    subgroup = 'energy',
    order = 'b[steam-power]-a[electroboiler]',
    place_result = name,
    stack_size = 50,
}
