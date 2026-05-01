require 'prelude'

function pipecoverspictures()
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
function pipepictures()
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

--- Empty sprite definition
function empty_sprite()
    return {
        filename = '__core__/graphics/empty.png',
        width = 1,
        height = 1,
    }
end


-------------------------------------------------------------------------------
-- Sound utility functions
-------------------------------------------------------------------------------

--- Generic working sound definition
function make_working_sound(filename, volume)
    volume = volume or 0.5
    return {
        sound = {
            filename = filename,
            volume = volume,
        },
        idle_sound = { filename = '__base__/sound/idle1.ogg', volume = 0.3 },
        apparent_volume = 1,
    }
end


-------------------------------------------------------------------------------
-- Circuit connector utilities
-------------------------------------------------------------------------------

--- Generate circuit connector sprites for a given position
function circuit_connector_definitions_at(position)
    return {
        points = {
            shadow = {
                green = { position[1] + 0.3, position[2] + 0.3 },
                red = { position[1] + 0.5, position[2] + 0.3 },
            },
            wire = {
                green = { position[1], position[2] },
                red = { position[1] + 0.2, position[2] - 0.1 },
            },
        },
        sprites = {
            connector_main = {
                filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png',
                width = 52,
                height = 50,
                scale = 0.5,
                shift = { position[1], position[2] },
            },
            led_blue = empty_sprite(),
            led_blue_off = empty_sprite(),
            led_green = empty_sprite(),
            led_red = empty_sprite(),
            led_light = { intensity = 0, size = 0.9 },
        },
    }
end


-------------------------------------------------------------------------------
-- Prototype utility functions
-------------------------------------------------------------------------------

--- Standard hit effects for entities
function hit_effects()
    return {
        type = 'create-entity',
        entity_name = 'spark-explosion',
        offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
        offsets = { { 0, 1 } },
        damage_type_filters = 'fire',
    }
end

--- Standard resistances table
function standard_resistances()
    return {
        { type = 'fire', percent = 70 },
        { type = 'impact', percent = 30 },
    }
end


-------------------------------------------------------------------------------
-- Math/position utilities
-------------------------------------------------------------------------------

-- Use prelude/table.lua instead:
--   table.vecsum(pos, offset)   -- vector addition (returns new)
--   table.vecscale(pos, factor) -- scalar multiply (returns new)
--   table.vecadd(pos, offset) -- in-place addition
--   table.vecmul(pos, factor) -- in-place multiply
