--! data: map generation presets for FeedsNSpeeds

local presets = data.raw['map-gen-presets'].default

presets['fns-default'] = {
    order = 'e[fns-default]',
    basic_settings = {
        autoplace_controls = {},
        property_expression_names = {},
    },
    advanced_settings = {},
}

presets['fns-rich'] = {
    order = 'f[fns-rich]',
    basic_settings = {
        autoplace_controls = {},
        property_expression_names = {},
    },
    advanced_settings = {},
}

presets['fns-sparse'] = {
    order = 'g[fns-sparse]',
    basic_settings = {
        autoplace_controls = {},
        property_expression_names = {},
    },
    advanced_settings = {},
}

presets['fns-marathon'] = {
    order = 'h[fns-marathon]',
    basic_settings = {
        autoplace_controls = {},
        property_expression_names = {},
    },
    advanced_settings = {
        difficulty_settings = {},
    },
}
