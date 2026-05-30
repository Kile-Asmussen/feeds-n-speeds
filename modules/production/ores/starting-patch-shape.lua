--! data: change the shapes of starting ore patches to not be so jagged

local blob_amplitude_scale_factor = 0.66

for _, name in ipairs{
    'default-iron-ore-patches',
    'default-copper-ore-patches',
    'default-coal-patches',
    'default-stone-patches',
} do

    local noise = data.raw['noise-expression'][name] or error('No such noise expression ' .. name)
    local expr = noise.expression

    local mult = expr:match('starting_blob_amplitude_multiplier%s*=%s*%d+%.%d+')
    local mult_num = tonumber(mult:match('%d+%.%d+')) * blob_amplitude_scale_factor
    local new_mult = mult:gsub('%d+%.%d+', tostring(mult_num))
    expr = expr:gsub(mult, new_mult)

    noise.expression = expr
end
