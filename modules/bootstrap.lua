require 'prelude'

local bootstrap = namespace 'modules.bootstrap'

bootstrap['data-prototypes'] = asset{
    'recipes.stone-furnace-alt',
    'tech.basic-materials-processing',
    'tech.wet-drilling',
    'tech.lab-tech',
    'entities.burner-mining-drill-fluid',
    'entities.electric-mining-drill-fluid',

    'worldgen.sulfur-ore',
    'worldgen.sulfur-ore-noise-expressions',
}

bootstrap['data-edits'] = asset{
    'entities.defluid-electric-mining-drill',
    'entities.enrich-rocks',
    'tech.earlygame-tech-tree',

    'worldgen.fix-ore-config',
    'worldgen.sulfur-item-variations',
}

bootstrap.control = asset{
    'scripts.freeplay'
}

return seal_namespace(bootstrap)