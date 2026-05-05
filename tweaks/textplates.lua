require 'prelude'

local textplates = namespace 'tweaks.textplates'
textplates.enabled = true

function textplates.data()
    if not textplates.enabled then return end

    if not mods['textplates'] then return end

    data:extend(require 'tweaks.textplates.tech')

    if mods['even-more-text-plates'] then
        data:extend(require 'tweaks.textplates.more-tech')
    end 
end

function textplates.data2()

    if not textplates.enabled then return end

    if not mods['textplates'] then return end

    textplates.fix_recipe('textplate-small-stone')
    textplates.fix_recipe('textplate-small-iron')
    textplates.fix_recipe('textplate-small-wood')
    textplates.fix_recipe('textplate-small-glass')
    textplates.fix_recipe('textplate-small-copper')

    textplates.fix_recipe('textplate-large-stone')
    textplates.fix_recipe('textplate-large-iron')
    textplates.fix_recipe('textplate-large-wood')
    textplates.fix_recipe('textplate-large-glass')
    textplates.fix_recipe('textplate-large-copper')

    textplates.fix_tech('textplates-plastic', 'plastic-bar', {'plastics'})
    textplates.fix_tech('textplates-plasticcoloured', 'plastic-bar', {'plastics'})
    textplates.fix_tech('textplates-steel', 'steel-plate', {'steel-processing'})
    textplates.fix_tech('textplates-concrete', 'concrete', {'concrete'})
    textplates.fix_tech('textplates-uranium', 'uranium-238', {'uranium-processing'})

    if enabled('tweaks.earlygame', 'extras.altrecipes') then
        textplates.fix_tech(fns 'textplates-stone', 'stone-brick', {fns 'basic-materials-processing'})
    end

    -- Gold textplates use sulfur; prerequisite depends on which sulfur path is active
    if enabled('extras.ores', 'extras.drills') then
        textplates.fix_tech('textplates-gold', 'sulfur', {fns 'wet-drilling'}, {
            type='mine-entity', entity=fns('sulfur-ore')
        })
    elseif enabled('extras.ores') then
        textplates.fix_tech('textplates-gold', 'sulfur', {fns 'sulfur-drilling'}, {
            type='mine-entity', entity=fns('sulfur-ore')
        })
    else
        textplates.fix_tech('textplates-gold', 'sulfur', {'sulfur-processing'})
    end
end

function textplates.fix_recipe(name)
    if not data.raw.recipe[name] then return end
    data.raw.recipe[name].enabled = false
end

-- material: craft-item trigger item (used when no explicit trigger given)
-- prerequisites: list of tech names to set as prerequisites, or nil for none
-- trigger: explicit research_trigger table, or nil to use craft-item on material
function textplates.fix_tech(name, material, prerequisites, trigger)
    if not data.raw.technology[name] then return end
    local tech = data.raw.technology[name]
    tech.unit = nil
    tech.prerequisites = prerequisites or {}
    tech.research_trigger = trigger or {
        type="craft-item",
        item=material,
        amount=1
    }
    tech.hidden = true
end

return seal_namespace(textplates)