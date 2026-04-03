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
  localised_name = { "", {"entity-name." .. fns 'small-radar'} },
  localised_description = {"", {"entity-description." .. fns 'small-radar'} },
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
