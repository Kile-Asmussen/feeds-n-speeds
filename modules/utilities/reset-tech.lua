--! control: console command to reset all technology effects
local fns = require 'fns'

local diff_reset = fns.locale_key("command", "reset-tech-effects-message")

commands.add_command("reset-tech-effects",
    {fns.locale_key("command", "reset-tech-effects")},
    function(command)
        game.players[command.player_index].force.reset_technology_effects()
    end
)