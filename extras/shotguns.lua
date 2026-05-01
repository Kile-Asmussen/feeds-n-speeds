require 'prelude'

local shotguns = namespace 'extras.shotguns'

function shotguns.data()
    data:extend{
        require 'extras.shotguns.turret'
    }
end

return shotguns:__seal()