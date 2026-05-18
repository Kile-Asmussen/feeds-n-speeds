
commands.add_command("reset-tech-effects",
    {fns_locale_key("command", "reset-tech-effects")},
    function(command)
        game.players[event.player_index].force.reset_technology_effects()
    end
)