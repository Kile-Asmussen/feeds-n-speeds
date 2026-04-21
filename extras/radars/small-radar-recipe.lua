return {
  enabled = false,
  ingredients = {
    {
      amount = 5,
      name = 'electronic-circuit',
      type = 'item'
    },
    {
      amount = 5,
      name = 'iron-gear-wheel',
      type = 'item'
    },
    {
      amount = 5,
      name = 'iron-plate',
      type = 'item'
    }
  },
  localised_name = { "", {fns('entity-name', 'small-radar')} },
  localised_description = {"", {fns("entity-description",'small-radar')} },
  name = fns 'small-radar',
  results = {
    {
      amount = 1,
      name = fns 'small-radar',
      type = 'item'
    }
  },
  type = 'recipe'
}
