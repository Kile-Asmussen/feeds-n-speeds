
for name, explode in pairs(data.raw.explosion) do
    if not explode.localised_name then
        local entity_name = name:before("-explosion")
        if name:endswith("-die") then
            entity_name = name:before("-die")
        elseif name:startswith("gleba-blood-explosion-") then
            entity_name = name:after("gleba-")
        end
        explode.localised_name = {"dying-explosion-name", {"entity-name." .. name:before("-explosion")}}
    end
end