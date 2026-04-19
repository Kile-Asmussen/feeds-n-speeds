require 'prelude'

local name = fns 'electroboiler'

return {
    type = 'item',
    name = name,
    icons = {
        {
            icon = '__base__/graphics/icons/boiler.png',
            icon_size = 64,
        },
        {
            icon = '__base__/graphics/icons/signal/signal-lightning.png',
            icon_size = 64,
            scale = 0.25,
            shift = { 8, -8 },
            tint = { r = 1.0, g = 0.9, b = 0.3 },
        },
    },
    subgroup = 'energy',
    order = 'b[steam-power]-a[electroboiler]',
    place_result = name,
    stack_size = 50,
}
