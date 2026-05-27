-- Script stub for test harness
-- Mimics Factorio's script global for event registration
--
-- Usage: require 'test.script' early in test harness


local namespace = require 'namespace'
local debuglib = require 'debuglib'

local script = namespace 'script'
local commands = namespace 'commands'

function script.__reset()
    script.__handlers = {
        on_init = {},
        on_load = {},
        on_configuration_changed = {},
        events = {},
        ticks = {}
    }
end

script.__reset() 
local function func(f)
    return debuglib.function_signature(f)
end

function script.on_init(handler)
    assert(type(handler) == 'function', "argument #1 must be a function")
    __log('on_init ' .. func(handler))
    table.insert(script.__handlers.on_init, handler)
end

function script.on_load(handler)
    assert(type(handler) == 'function', "argument #1 must be a function")
    __log('on_load ' .. func(handler))
    table.insert(script.__handlers.on_load, handler)
end

function script.on_configuration_changed(handler)
    assert(type(handler) == 'function', "argument #1 must be a function")
    __log('on_configuration_changed ' .. func(handler))
    table.insert(script.__handlers.on_configuration_changed, handler)
end

function script.on_event(event, handler, filters)
    filters = filters or {}
    assert(type(event) == 'number', "argument #1 must be a number")
    assert(type(handler) == 'function', "argument #2 must be a function")
    assert(type(filters) == 'table', "argument #3 must be a table")


    if type(event) == 'table' then
        for _, e in ipairs(event) do
            script.on_event(e, handler, filters)
        end
        return
    end

    local filtering = ' '
    if #filters > 0 then
        filtering = '(filters:' .. #filters .. ') '
    end
    __log(defines.event_names[event] .. filtering .. func(handler))

    script.__handlers.events[event] =  script.__handlers.events[event] or {}
    table.insert(script.__handlers.events[event], { handler = handler, filters = filters })
end

function script.on_nth_tick(tick, handler)
    assert(type(tick) == 'number', "argument #1 must be a number")
    assert(type(handler) == 'function', "argument #2 must be a function")
    __log('on_nth_tick(' .. tick .. ') ' .. func(handler))
    script.__handlers.ticks[tick] = script.__handlers.ticks[tick] or {}
    table.insert(script.__handlers.ticks[tick], handler)
end

function commands.add_command(command, localisation_string, handler)
    __log('/' .. command .. ' ' .. debuglib.p(localisation_string) .. ' ' .. func(handler))
end

rawset(_ENV, 'script', script:seal())
rawset(_ENV, 'commands', commands:seal())
