Item = require("utils.objects.item")

local placeables = {
    ["Saw"] = Item:new(1, "Saw", "A tool for cutting materials.", "assets/items/objects/iron_ingot.png")
}

function placeables.getPlaceables()
    return placeables
end

function placeables.getPlaceableByName(name)
    return placeables[name]
end

return placeables