
local function reset_tech(event)
    game.players[event.player_index].force.reset_technology_effects()
end

local command_list = {
    ['reset-tech'] = reset_tech
}

local function command(event)
    if command_list[event.message] and event.player_index then
        command_list[event.message](event)
    end
end


script.on_event(defines.events.on_console_chat, command)