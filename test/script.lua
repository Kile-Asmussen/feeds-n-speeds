-- Script stub for test harness
-- Mimics Factorio's script global for event registration
--
-- Usage: require 'test.script' early in test harness

require 'prelude'

local script = namespace 'script'

-----------------------------------------------------------------------
-- Internal storage for registered handlers
-----------------------------------------------------------------------

script.__handlers = {
    on_init = nil,
    on_load = nil,
    on_configuration_changed = nil,
    events = {},  -- [event_id] = { handler = fn, filters = ... }
}

-----------------------------------------------------------------------
-- Lifecycle event registration
-----------------------------------------------------------------------

--- Register handler for on_init (new game)
--- @param handler function
function script.on_init(handler)
    script.__handlers.on_init = handler
    log('script.on_init registered')
end

--- Register handler for on_load (save loaded)
--- @param handler function
function script.on_load(handler)
    script.__handlers.on_load = handler
    log('script.on_load registered')
end

--- Register handler for on_configuration_changed (mod updates)
--- @param handler function
function script.on_configuration_changed(handler)
    script.__handlers.on_configuration_changed = handler
    log('script.on_configuration_changed registered')
end

-----------------------------------------------------------------------
-- Event registration
-----------------------------------------------------------------------

--- Register handler for game events
--- @param event number|number[] Event ID or array of event IDs
--- @param handler function|nil Handler function, or nil to unregister
--- @param filters table|nil Optional event filters
function script.on_event(event, handler, filters)
    if type(event) == 'table' then
        -- Array of events
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
    if handler then
        log('script.on_event registered: ' .. event_name)
    else
        log('script.on_event unregistered: ' .. event_name)
    end
end

--- Register handler for nth_tick
--- @param tick number|nil Tick interval, or nil to unregister
--- @param handler function|nil Handler function
function script.on_nth_tick(tick, handler)
    if tick then
        script.__handlers.events['nth_tick_' .. tick] = handler and {
            handler = handler,
            tick = tick,
        } or nil
        log('script.on_nth_tick registered: every ' .. tick .. ' ticks')
    end
end

-----------------------------------------------------------------------
-- Test helpers
-----------------------------------------------------------------------

--- Find event name from defines.events (for logging)
--- @param event_id number
--- @return string|nil
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

--- Simulate firing an event (for testing)
--- @param event_id number
--- @param event_data table
function script._fire_event(event_id, event_data)
    local registration = script.__handlers.events[event_id]
    if registration and registration.handler then
        registration.handler(event_data)
    end
end

--- Simulate on_init (for testing)
function script._fire_on_init()
    if script.__handlers.on_init then
        script.__handlers.on_init()
    end
end

--- Simulate on_load (for testing)
function script._fire_on_load()
    if script.__handlers.on_load then
        script.__handlers.on_load()
    end
end

--- Simulate on_configuration_changed (for testing)
--- @param data table|nil Configuration changed data
function script._fire_on_configuration_changed(data)
    if script.__handlers.on_configuration_changed then
        script.__handlers.on_configuration_changed(data or {})
    end
end

--- Reset all handlers (for test isolation)
function script._reset()
    script.__handlers = {
        on_init = nil,
        on_load = nil,
        on_configuration_changed = nil,
        events = {},
    }
end

-----------------------------------------------------------------------
-- Export to global
-----------------------------------------------------------------------

_G.script = script:__seal()
