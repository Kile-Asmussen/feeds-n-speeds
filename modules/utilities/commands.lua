require 'prelude'

local function reset_tech(event)
    if event.message == 'reset-tech' and event.player_index then
        game.players[event.player_index].force.reset_technology_effects()
    end
end

local command_list = {
    ['reset-tech'] = reset_tech
}

local function command(event)
    if command_list[message]

return function()
    script.on_event(defines.events.on_console_chat, start.fix_technologies)
end