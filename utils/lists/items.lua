Item = require("utils.objects.item")

local items = {
    ["Iron Ingot"] = Item:new(1, "Iron Ingot", "Metal", "A basic crafting material.", "assets/items/objects/iron_ingot.png", 0.08)
}

function items.getItems()
    return items
end

function items.getItemByName(name)
    return items[name]
end

return items