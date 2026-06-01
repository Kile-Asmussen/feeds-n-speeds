--! data: miscellaneous changes, including steel plate being cheaper

data.raw.recipe['steel-plate'].ingredients[1].amount = 3
data.raw.recipe['steel-plate'].energy_required = data.raw.recipe['iron-plate'].energy_required * 3

data.raw.recipe['stone-brick'].energy_required = data.raw.recipe['iron-plate'].energy_required * 1.5
data.raw.recipe['stone-brick'].ingredients[1].amount = 3
data.raw.recipe['stone-brick'].results[1].amount = 2
