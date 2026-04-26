require 'prelude'

local textplates = namespace 'tweaks.textplates'
textplates.enabled = true

function textplates.data()
    data:extend(require 'tweaks.textplates.tech')
end

function textplates.data_updates()

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

    textplates.fix_tech('textplates-plastic', 'plastic-bar')
    textplates.fix_tech('textplates-plasticcoloured', 'plastic-bar')
    textplates.fix_tech('textplates-steel', 'steel-plate')
    textplates.fix_tech('textplates-gold', 'sulfur')
    textplates.fix_tech('textplates-uranium', 'uranium-238')
    textplates.fix_tech('textplates-concrete', 'concrete')
end

function textplates.fix_recipe(name)
    if not data.raw.recipe[name] then return end
    data.raw.recipe[name].enabled = false
end

function textplates.fix_tech(name, material)
    if not data.raw.technology[name] then return end
    data.raw.technology[name].unit = nil
    data.raw.technology[name].prerequisites = {}
    data.raw.technology[name].research_trigger = {
        type="craft-item",
        item=material,
        amount=1
    }
end