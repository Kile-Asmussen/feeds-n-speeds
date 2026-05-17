
local prefixes = {}

for size in ipairs{"small-", "large-"} do
    for material in ipairs{
        "concrete-",
        "copper-",
        "glass-",
        "gold-",
        "iron-",
        "plastic-",
        "plasticcoloured-",
        "steel-",
        "stone-",
        "uranium-",
        "wood-",
    } do
        table.insert(prefixes, "textplates-"..size..material)
    end
end

for name, _ in pairs(data.raw.item) do
    for _, prefix in ipairs(prefixes) do
        if item.name:startswith(prefix) then
            data.raw.item[name] = nil
        end
    end
end