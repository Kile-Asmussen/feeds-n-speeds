-- Script stub for test harness
-- Mimics Factorio's script global for event registration
--
-- Usage: require 'test.script' early in test harness

local fns = require 'fns'
local table = fns.table

local namespace = require 'namespace'
local debuglib = require 'debuglib'

local script = namespace 'test.script'
local commands = namespace 'test.commands'

local handlers = { events = {}, ticks = {} }

local function one_registration_only(name)
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
    assert(table.reverse_lookup(defines.events, event), "script.on_event: argument #1 must be in defines.events")
    assert(type(handler) == 'function', "script.on_event: argument #2 must be a function")
    assert(type(filters) == 'table', "script.on_event: argument #3 must be a table")

    local filtering = ' '
    if #filters > 0 then
        filtering = '(filters:' .. #filters .. ') '
    end
    __log(defines.event_names[event] .. filtering .. debuglib.function_signature(handler))

    if handlers.events[event] then
        error("duplicate on_event(defines.event." .. table.reverse_lookup(defines.event, event) .. ") declaration!", 2)
    end
    handlers.events[event] = { handler = handler, filters = filters }
end



function script.on_nth_tick(tick, handler)
    assert(type(tick) == 'number' and math.floor(tick) == tick, "argument #1 must be an integer")
    assert(type(handler) == 'function', "argument #2 must be a function")
    __log('on_nth_tick(' .. tick .. ') ' .. debuglib.function_signature(handler)(handler))
    if handlers.ticks[tick] then error("duplicate on_nth_tick(" .. tick .. ") declaration!", 2) end
    handlers.ticks[tick] = handler
end

local registered_commands = {}

function commands.add_command(command, localisation_string, handler)
    if registered_commands[command] then error("duplicate /" .. command .. " declared!", 2) end
    __log('/' .. command .. ' ' .. debuglib.p(localisation_string) .. ' ' .. debuglib.function_signature(handler))
    registered_commands[command] = handler
end

script:seal()
commands:seal()


local function begin_control_stage()
    rawset(_ENV, 'script', script)
    rawset(_ENV, 'storage', {})
    rawset(_ENV, 'commands', commands)
end
rawset(_ENV, 'begin_control_stage', begin_control_stage)