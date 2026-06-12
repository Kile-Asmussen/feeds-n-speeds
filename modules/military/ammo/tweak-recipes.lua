--! data: changes to ammo recipes to require sulfur

local fns = require 'fns'
local table = fns.table
local puts = fns.gadgets.throughputs
local recipes = data.raw.recipe
local merge = table.merge

merge(recipes, {

    ['artillery-shell'] = merge{
        ingredients = puts{
            ['explosives'] = 10,
            ['steel-plate'] = 2,
            ['calcite'] = 1,
            ['radar'] = 1,
        }
    },

    ['destroyer-capsule'] = merge{
        ingredients = puts{
            ['solid-fuel'] = 5,
            ['engine-unit'] = 5,
            ['advanced-circuit'] = 5,
            ['copper-cable'] = 10,
            ['battery'] = 10,
        }
    },

    ['defender-capsule'] = merge{
        ingredients = puts{
            ['solid-fuel'] = 1,
            ['engine-unit'] = 1,
            ['advanced-circuit'] = 1,
            ['iron-gear-wheel'] = 2,
            ['piercing-rounds-magazine'] = 1,
        }
    },

    ['distractor-capsule'] = merge{
        ingredients = puts{
            ['solid-fuel'] = 3 ,
            ['engine-unit'] = 3 ,
            ['advanced-circuit'] = 3 ,
            ['small-lamp'] = 3 ,
            ['battery'] = 3 ,
        }
    },

    ['explosive-rocket'] = merge{
        ingredients = puts{
            ['rocket-fuel'] = 2,
            ['explosives'] = 5,
            ['steel-plate'] = 2,
            ['electronic-circuit'] = 3,
        }
    },

    ['firearm-magazine'] = merge{
        energy_required = 2,
        results = puts { ['firearm-magazine'] = 2 },
        ingredients = puts{
            ['iron-plate'] = 1,
            ['copper-plate'] = 1,
            ['sulfur'] = 1,
            ['coal'] = 1,
        }
    },

    ['flamethrower-ammo'] = merge{
        ingredients = puts{
            ['crude-oil'] = 100,
            ['barrel'] = 1,
        }
    },

    ['grenade'] = merge{
        ingredients = puts{
            ['steel-plate'] = 1,
            ['sulfur'] = 5,
            ['coal'] = 5,
        }
    },

    ['shotgun-shell'] = merge{
        ingredients = puts{
            ['copper-plate'] = 1,
            ['iron-plate'] = 1,
            ['sulfur'] = 2,
            ['coal'] = 2,
        },
        results = puts { ['shotgun-shell'] = 2 },
        energy_required = 4,
    },


    ['piercing-rounds-magazine'] = merge{ 
        energy_required = 6,
        results = puts { ['piercing-rounds-magazine'] = 2 },
        ingredients = puts{
            ['steel-plate'] = 1,
            ['firearm-magazine'] = 2,
            ['sulfur'] = 1,
            ['coal'] = 1,
        }
    },

    ['piercing-shotgun-shell'] = merge{
        energy_required = 8,
        results = puts { ['piercing-shotgun-shell'] = 2 },
        ingredients = puts{
            ['shotgun-shell'] = 2,
            ['steel-plate'] = 1,
            ['sulfur'] = 1,
            ['coal'] = 1,
        }
    },


    ['slowdown-capsule'] = merge{
        category = 'crafting-with-fluid',
        ingredients = puts{
            ['sulfur'] = 5,
            ['iron-stick'] = 5,
            ['crude-oil'] = 50,
            ['grenade'] = 1,
        },
    },

    ['poison-capsule'] = merge{
        category = 'crafting-with-fluid',
        ingredients = puts{
            ['solid-fuel'] = 1,
            ['copper-cable'] = 5,
            ['sulfuric-acid'] = 50,
            ['grenade'] = 1
        }
    },


    ['rocket'] = merge{
        ingredients = puts{
            ['rocket-fuel'] = 1,
            ['explosives'] = 1,
            ['steel-plate'] = 1,
            ['electronic-circuit'] = 3,
        }
    },


    ['railgun-ammo'] = merge{
        ingredients = puts{
            ['tungsten-carbide'] = 1,
            ['steel-plate'] = 5,
        }
    },
})