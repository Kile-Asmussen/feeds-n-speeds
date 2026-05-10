require 'prelude'

return function()
    data.raw.item.sulfur.pictures = table.map(
        {
            '__base__/graphics/icons/sulfur.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-1.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-2.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-3.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-4.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-5.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-6.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-7.png',
        },
        function(filename) return {
            filename = filename,
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        } end
    )
end