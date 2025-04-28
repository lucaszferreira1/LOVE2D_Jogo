Placeable = require("utils.objects.placeable")

local placeables = {
    ["Saw"] = Placeable:new(1, "Saw", "Machines", "A tool for cutting materials.", -1, -1, "left", 1, 1, "assets/items/placeables/saw.png", "assets/items/placeables/saw.png", 0.07),
}

function placeables.getPlaceables()
    return placeables
end

function placeables.getPlaceableByName(name)
    return placeables[name]
end

return placeables