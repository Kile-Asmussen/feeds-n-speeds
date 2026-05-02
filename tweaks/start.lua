require 'prelude'

local start = namespace 'tweaks.start'
start.enabled = true

function start.control()

    script.on_init(start.inventory())

end

function start.inventory()
    
end

return start:__seal()