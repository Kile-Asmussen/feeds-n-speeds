
local function pipecoverspictures()
    local base_path = '__base__/graphics/entity/pipe-covers/'
    return {
        north = {
            layers = {
                {
                    filename = base_path .. 'pipe-cover-north.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                },
                {
                    filename = base_path .. 'pipe-cover-north-shadow.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                    draw_as_shadow = true,
                },
            },
        },
        east = {
            layers = {
                {
                    filename = base_path .. 'pipe-cover-east.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                },
                {
                    filename = base_path .. 'pipe-cover-east-shadow.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                    draw_as_shadow = true,
                },
            },
        },
        south = {
            layers = {
                {
                    filename = base_path .. 'pipe-cover-south.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                },
                {
                    filename = base_path .. 'pipe-cover-south-shadow.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                    draw_as_shadow = true,
                },
            },
        },
        west = {
            layers = {
                {
                    filename = base_path .. 'pipe-cover-west.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                },
                {
                    filename = base_path .. 'pipe-cover-west-shadow.png',
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    priority = 'extra-high',
                    draw_as_shadow = true,
                },
            },
        },
    }
end

--- Pipe pictures for entities with visible pipe connections
local function pipepictures()
    return {
        straight_vertical_single = { filename = '__base__/graphics/entity/pipe/pipe-straight-vertical-single.png', width = 80, height = 80 },
        straight_vertical = { filename = '__base__/graphics/entity/pipe/pipe-straight-vertical.png', width = 64, height = 64 },
        straight_vertical_window = { filename = '__base__/graphics/entity/pipe/pipe-straight-vertical-window.png', width = 64, height = 64 },
        straight_horizontal = { filename = '__base__/graphics/entity/pipe/pipe-straight-horizontal.png', width = 64, height = 64 },
        straight_horizontal_window = { filename = '__base__/graphics/entity/pipe/pipe-straight-horizontal-window.png', width = 64, height = 64 },
        corner_up_right = { filename = '__base__/graphics/entity/pipe/pipe-corner-up-right.png', width = 64, height = 64 },
        corner_up_left = { filename = '__base__/graphics/entity/pipe/pipe-corner-up-left.png', width = 64, height = 64 },
        corner_down_right = { filename = '__base__/graphics/entity/pipe/pipe-corner-down-right.png', width = 64, height = 64 },
        corner_down_left = { filename = '__base__/graphics/entity/pipe/pipe-corner-down-left.png', width = 64, height = 64 },
        t_up = { filename = '__base__/graphics/entity/pipe/pipe-t-up.png', width = 64, height = 64 },
        t_down = { filename = '__base__/graphics/entity/pipe/pipe-t-down.png', width = 64, height = 64 },
        t_right = { filename = '__base__/graphics/entity/pipe/pipe-t-right.png', width = 64, height = 64 },
        t_left = { filename = '__base__/graphics/entity/pipe/pipe-t-left.png', width = 64, height = 64 },
        cross = { filename = '__base__/graphics/entity/pipe/pipe-cross.png', width = 64, height = 64 },
        ending_up = { filename = '__base__/graphics/entity/pipe/pipe-ending-up.png', width = 64, height = 64 },
        ending_down = { filename = '__base__/graphics/entity/pipe/pipe-ending-down.png', width = 64, height = 64 },
        ending_right = { filename = '__base__/graphics/entity/pipe/pipe-ending-right.png', width = 64, height = 64 },
        ending_left = { filename = '__base__/graphics/entity/pipe/pipe-ending-left.png', width = 64, height = 64 },
    }
end

rawset(_ENV, 'pipepictures', pipepictures)
rawset(_ENV, 'pipecoverspictures', pipecoverspictures)