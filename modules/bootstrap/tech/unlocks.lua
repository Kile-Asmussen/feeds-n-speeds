local fns = require 'fns'

local recipe = data.raw.recipe

recipe['transport-belt'].auto_unlocked_by = fns 'lab-tech'
recipe['inserter'].auto_unlocked_by = fns 'lab-tech'
recipe['lab'].auto_unlocked_by = fns 'lab-tech'

recipe['burner-inserter'].auto_unlocked_by = fns 'basic-materials-processing'

recipe['iron-stick'].auto_unlocked_by = 'steel-processing'
recipe['steel-plate'].auto_unlocked_by = 'steel-processing'
recipe['iron-gear-wheel'].auto_unlocked_by = 'steel-processing'
recipe['iron-chest'].auto_unlocked_by = 'steel-processing'
recipe['steel-chest'].auto_unlocked_by = 'steel-processing'

data.raw.inserter['burner-inserter'] = nil
data.raw.item['burner-inserter'] = nil
data.raw.recipe['burner-inserter'] = nil