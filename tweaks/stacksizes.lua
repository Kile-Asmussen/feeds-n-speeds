require 'prelude'

local stacks = namespace('tweaks.stacks')

stacks.toggle = 'feeds-n-speeds-tweaks-stacks-enable'
stacks.enabled = true

function stacks.data_final_fixes()

    if not stacks.enabled then return end

    
end

return stacks:__seal()