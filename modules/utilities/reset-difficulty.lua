--! control: console command to reset/set technology cost multiplier
local fns = require 'fns'

local diff_reset = fns.locale_key("command", "reset-tech-cost-message")
local diff_invalid = fns.locale_key("command", "reset-tech-cost-error-message")

commands.add_command("reset-difficulty",
    {fns.locale_key("command", "reset-tech-cost")},
    function(command)
        local diff = tonumber(command.parameter) or 1
        if diff ~= math.floor(diff) or diff < 1 or diff > 1000 then
            game.print({diff_invalid})
        else
            game.difficulty_settings.technology_price_multiplier = diff
            game.print({diff_reset, diff})
        end
    end
)