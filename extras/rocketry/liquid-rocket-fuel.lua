require 'prelude'

local fuel = data.raw.fluid['light-oil']

fuel.name = fns 'rocket-fuel'
fuel.icons = {
    {
        icon = fuel.icon,
        icon_size = 64,
        scale=0.5,
    },
    {
        icon = data.raw.item['rocket-fuel'].icon,
        icon_size = 64,
        float=true,
        scale=0.5,
    },
}

