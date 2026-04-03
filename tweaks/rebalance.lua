require 'prelude'

local miningspeed = namespace 'tweaks.miningspeed'

miningspeed.toggle = 'feeds-n-speeds-tweaks-miningspeed-enable'
miningspeed.enabled = true

function miningspeed.data_updates()

    if not miningspeed.enabled then return end

end

return miningspeed:__seal()