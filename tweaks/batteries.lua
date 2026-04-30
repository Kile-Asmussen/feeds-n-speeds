require 'prelude'

local plastics = namespace 'tweaks.batteries'

function plastics.data_updates()

    data.raw.recipe['battery'].ingredients = {
        { type='item', name='iron-plate', amount=1 },
        { type='item', name='copper-plate', amount=1 },
        { type='item', name='plastic-bar', amount=1 },
        { type='fluid', name='sulfuric-acid', amount=20 },
    }

    table.insert(data.raw.technology['battery'].prerequisites, 'plastics')
    table.insert(data.raw.technology['modules'].prerequisites, 'battery')

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

end

return plastics:__seal()