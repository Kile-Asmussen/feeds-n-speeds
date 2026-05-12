require 'prelude'

local construction = namespace 'construction'

construction.data = asset{
    '.recipes.crafting-times',
    '.entities.mining-times',
}

return seal_namespace(construction)