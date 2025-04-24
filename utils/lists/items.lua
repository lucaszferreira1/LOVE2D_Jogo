Item = require("utils.objects.item")

local items = {
    ["Iron Ingot"] = Item:new(1, "Iron Ingot", "A basic crafting material.", "assets/items/objects/iron_ingot.png", 0.07)
}

function items.getItems()
    return items
end

function items.getItemByName(name)
    return items[name]
end

return items