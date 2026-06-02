-- Script stub for test harness
-- Mimics Factorio's script global for event registration
--
-- Usage: require 'test.script' early in test harness

local fns = require 'fns'
local table = fns.table

local namespace = require 'namespace'
local debuglib = require 'debuglib'

local script = namespace 'script'
local commands = namespace 'commands'

local handlers = { events = {}, ticks = {} }

local one_registration_only(name)
    return function(handler)
        if handler == nil then
            handlers[name] = nil
            __log(name .. ' deleted')
        else
            assert(type(handler) == 'function', "script." .. name .. ": argument #1 must be a function")
            if handlers[name] then error("duplicate on_init declaration!", 2)  end
            __log(name .. ' ' .. debuglib.function_signature(handler))
            handlers[name] = handler
        end
    end
end

script.on_init = one_registration_only 'on_init'
script.on_load = one_registration_only 'on_load'
script.on_configuration_changed = one_registration_only 'on_configuration_changed'

function script.on_event(event, handler, filters)

    if type(event) == 'table' then
        for _, e in ipairs(event) do
            script.on_event(e, handler, filters)
        end
        return
    end

    filters = filters or {}
    assert(table.find(defines.events, fns.utils.eq(event)), "script.on_event: argument #1 must be in defines.events")
    assert(type(handler) == 'function', "script.on_event: argument #2 must be a function")
    assert(type(filters) == 'table', "script.on_event: argument #3 must be a table")

    local filtering = ' '
    if #filters > 0 then
        filtering = '(filters:' .. #filters .. ') '
    end
    __log(defines.event_names[event] .. filtering .. func(handler))

    if handlers.events[event] then
        error("duplicate on_event(defines.event." .. table.reverse_lookup(event) .. ") declaration!", 2)
    end
    handlers.events[event] = { handler = handler, filters = filters }
end



function script.on_nth_tick(tick, handler)
    assert(type(tick) == 'number' and math.floor(tick) == tick, "argument #1 must be an integer")
    assert(type(handler) == 'function', "argument #2 must be a function")
    __log('on_nth_tick(' .. tick .. ') ' .. func(handler))
    if handlers.ticks[tick] then error("duplicate on_nth_tick(" .. tick .. ") declaration!", 2) end
    handlers.ticks[tick] = handler
end

local commands = {}

function commands.add_command(command, localisation_string, handler)
    if commands[command] then error("duplicate /" .. command " declared!", 2) end
    __log('/' .. command .. ' ' .. debuglib.p(localisation_string) .. ' ' .. func(handler))
end

rawset(_ENV, 'script', script:seal())
rawset(_ENV, 'commands', commands:seal())
