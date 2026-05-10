require 'prelude'

local bootstrap = namespace 'modules.bootstrap'

bootstrap.data = asset{
    'recipes.stone-furnace-alt',

    'entities.enrich-rocks',
    'entities.burner-miner',
    'entities.electric-miner',

    'tech.earlygame-tech-tree',
    'tech.wet-drilling',
    'tech.lab-tech',    

    'worldgen.sulfur-ore',
    'worldgen.sulfur-ore-noise-expressions',
    'worldgen.sulfur-item-variations',

    ['worldgen.fix-ore-config'] = asset{
        'worldgen.sulfur-ore',
        'worldgen.sulfur-ore-noise-expressions',
    }
}

bootstrap.control = asset{
    'scripts.freeplay'
}

return seal_namespace(bootstrap)