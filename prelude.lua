require 'prelude.table'
require 'prelude.string'


__namespace_mt = {
    __tostring = function(ns) return rawget(table, '__path') or '' end,
    __index = function(table, name) error(rawget(table, '__path') .. '.' .. name .. ' not found') end,
    __newindex = function(table, name, value)
        if type(name) == 'number' then
            error('namespaces are not arrays')
        end
        rawset(table, name, value)
    end,
    __call = function(table, name)
        return rawget(table, name)
    end,
    __metatable = '__namespace_mt'
}

__namespace_builder_mt = {
    __tostring = function(builder)
        return table.concat(builder['%path'], '.')
    end,

    __newindex = function(builder, name, tbl)
        if type(tbl) ~= 'table' then
            error('cannot create non-table namespace')
        elseif table.is_populated(tbl) then
            error('cannot create namespace from non-empty table')
        end

        local _ = builder[name]
    end,

    __index = function(builder, name)
        if not name:match('^[a-zA-Z_][a-zA-Z_0-9]*$') then
            error('bad namespace name ' .. name)
        end

        table.insert(builder['%path'], name)

        local extant = rawget(builder['%table'], name)

        if extant ~= nil then
            if type(extant) ~= 'table' then
                error(tostring(builder) .. ' is a ' .. type(extant))
            end

            if getmetatable(extant) ~= _G.__namespace_mt.__metatable then
                error('table ' .. tostring(builder) .. ' is not a namespace')
            end

            builder['%table'] = extant

            return builder
        end

        local tbl = {
            __path = tostring(builder),
        }

        setmetatable(tbl, _G.__namespace_mt)

        rawset(builder['%table'], name, tbl)

        builder['%table'] = tbl

        return builder
    end,

    __metatable = '__namespace_builder_mt'
}


function namespace()
    local res = { ['%table'] = _G, ['%path'] = {} }
    setmetatable(res, _G.__namespace_builder_mt)
    return res
end