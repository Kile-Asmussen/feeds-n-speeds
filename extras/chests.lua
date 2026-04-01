require 'prelude'

local chests = namespace 'extras.chests'

chests.toggle = 'feeds-n-speeds-extras-chests-enable'
chests.enabled = true

function chest.data()
    if not chests.enabled then
        log("Chest extras disabled")
        return
    end

    log("Chest extras disabled")

    data:extend{
        require('prototypes.big_chest'),
    }
end