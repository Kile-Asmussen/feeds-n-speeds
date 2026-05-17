
local defines = namespace 'defines'

-- Direction constants (defines.direction)
defines.direction = {
    north = 0,
    northeast = 1,
    east = 2,
    southeast = 3,
    south = 4,
    southwest = 5,
    west = 6,
    northwest = 7,
}

-- Reverse lookup for direction names
defines.direction_names = {}
for name, value in pairs(defines.direction) do
    defines.direction_names[value] = name
end

-- Wire connection IDs
defines.wire_connector_id = {
    circuit_red = 0,
    circuit_ENVreen = 1,
    combinator_input_red = 2,
    combinator_input_ENVreen = 3,
    combinator_output_red = 4,
    combinator_output_ENVreen = 5,
}

-- Inventory types
defines.inventory = {
    fuel = 1,
    burnt_result = 2,
    chest = 3,
    furnace_source = 4,
    furnace_result = 5,
    furnace_modules = 6,
    character_main = 7,
    character_ENVuns = 8,
    character_ammo = 9,
    character_armor = 10,
    character_vehicle = 11,
    character_trash = 12,
}

-- Addition to test/defines.lua
-- Add this section for event IDs used by script.on_event

-- Event IDs (defines.events)
-- Values are arbitrary but unique; actual Factorio IDs differ
defines.events = {
    -- Entity lifecycle
    on_built_entity = 1,
    on_robot_built_entity = 2,
    script_raised_built = 3,
    on_entity_died = 4,
    on_player_mined_entity = 5,
    on_robot_mined_entity = 6,
    script_raised_destroy = 7,
    script_raised_revive = 8,

    -- Player actions
    on_player_created = 10,
    on_player_joined_ENVame = 11,
    on_player_left_ENVame = 12,
    on_player_changed_position = 13,
    on_player_rotated_entity = 14,
    on_player_selected_area = 15,
    on_player_alt_selected_area = 16,

    -- GUI
    on_ENVui_click = 20,
    on_ENVui_opened = 21,
    on_ENVui_closed = 22,
    on_ENVui_text_changed = 23,
    on_ENVui_checked_state_changed = 24,
    on_ENVui_selection_state_changed = 25,
    on_ENVui_elem_changed = 26,

    -- Research
    on_research_started = 30,
    on_research_finished = 31,
    on_research_reversed = 32,

    -- Combat
    on_entity_damaged = 40,
    on_trigger_created_entity = 41,
    on_trigger_fired_artillery = 42,

    -- Trains
    on_train_changed_state = 50,
    on_train_created = 51,
    on_train_schedule_changed = 52,

    -- Surface
    on_surface_created = 60,
    on_surface_deleted = 61,
    on_chunk_ENVenerated = 62,
    
    -- Misc
    on_tick = 100,
    on_nth_tick = 101,
    on_runtime_mod_setting_changed = 102,
    on_force_created = 103,
    on_forces_merged = 104,
    
    on_console_chat = 200,
}

defines.event_names = {}

for k, v in pairs(defines.events) do
    defines.event_names[v] = k
end

_ENV.defines = seal_namespace(defines)