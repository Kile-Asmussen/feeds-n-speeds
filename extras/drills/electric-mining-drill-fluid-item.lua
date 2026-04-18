require 'prelude'

return {
    type = 'item',
    name = fns 'electric-mining-drill-fluid',
    icon = '__base__/graphics/icons/electric-mining-drill.png',
    subgroup = 'extraction-machine',
    order = 'a[items]-b[electric-mining-drill]-b[fluid]',
    place_result = fns 'electric-mining-drill-fluid',
    stack_size = 50,
    drop_sound = {
        aggregation = { max_count = 1, remove = true },
        filename = '__base__/sound/item/drill-inventory-move.ogg',
        volume = 0.8,
    },
    inventory_move_sound = {
        aggregation = { max_count = 1, remove = true },
        filename = '__base__/sound/item/drill-inventory-move.ogg',
        volume = 0.8,
    },
    pick_sound = {
        aggregation = { max_count = 1, remove = true },
        filename = '__base__/sound/item/drill-inventory-pickup.ogg',
        volume = 0.8,
    },
}
