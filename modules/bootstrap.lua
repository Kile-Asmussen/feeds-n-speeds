require 'prelude'

local bootstrap = namespace 'modules.bootstrap'

bootstrap.prototypes = asset{
    'recipe.stone-furnace-alt',
    'tech.basic-materials-processing',
}

bootstrap.data_edits = asset{
    'edit.rocks'
}

return seal_namespace(bootstrap)