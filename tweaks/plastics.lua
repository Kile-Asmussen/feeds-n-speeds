require 'prelude'

local plastics = namespace 'tweaks.plastics'

function plastics.data_updates()

    data.raw.recipe['battery'].ingredients = {
        { type='item', name='iron-plate', amount=1 },
        { type='item', name='copper-plate', amount=1 },
        { type='item', name='plastic-bar', amount=1 },
        { type='item', name='sulfuric-acid', amount=20 },
    }

    table.insert(data.raw.recipe['speed-module'].ingredients,
        { type='item', name='battery', amount=2 }
    )
    table.insert(data.raw.recipe['productivity-module'].ingredients,
        { type='item', name='battery', amount=2 }
    )
    table.insert(data.raw.recipe['efficiency-module'].ingredients,
        { type='item', name='battery', amount=2 }
    )
    table.insert(data.raw.recipe['quality-module'].ingredients,
        { type='item', name='battery', amount=2 }
    )
    table.insert(data.raw.technology['battery'].prerequisites, 'plastics')

end

return plastics:__seal