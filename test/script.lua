-- Script stub for test harness
-- Mimics Factorio's script global for event registration
--
-- Usage: require 'test.script' early in test harness

require 'prelude'

local script = namespace 'script'

script.__handlers = {
    on_init = nil,
    on_load = nil,
    on_configuration_changed = nil,
    events = {},  -- [event_id] = { handler = fn, filters = ... }
}

function script.on_init(handler)
    script.__handlers.on_init = handler
end

function script.on_load(handler)
    script.__handlers.on_load = handler
end

function script.on_configuration_changed(handler)
    script.__handlers.on_configuration_changed = handler
end

function script.on_event(event, handler, filters)
    if type(event) == 'table' then
        for _, e in ipairs(event) do
            script.on_event(e, handler, filters)
        end
        return
    end

    script.__handlers.events[event] = handler and {
        handler = handler,
        filters = filters,
    } or nil

    local event_name = script._find_event_name(event) or tostring(event)
end

function script.on_nth_tick(tick, handler)
    if tick then
        script.__handlers.events['nth_tick_' .. tick] = handler and {
            handler = handler,
            tick = tick,
        } or nil
    end
end

function script._find_event_name(event_id)
    if defines and defines.events then
        for name, id in pairs(defines.events) do
            if id == event_id then
                return name
            end
        end
    end
    return nil
end

function script._fire_event(event_id, event_data)
    local registration = script.__handlers.events[event_id]
    if registration and registration.handler then
        registration.handler(event_data)
    end
end

function script._fire_on_init()
    if script.__handlers.on_init then
        script.__handlers.on_init()
    end
end

function script._fire_on_load()
    if script.__handlers.on_load then
        script.__handlers.on_load()
    end
end

function script._fire_on_configuration_changed(data)
    if script.__handlers.on_configuration_changed then
        script.__handlers.on_configuration_changed(data or {})
    end
end

function script._reset()
    script.__handlers = {
        on_init = nil,
        on_load = nil,
        on_configuration_changed = nil,
        events = {},
    }
end

_G.script = script:__seal()
