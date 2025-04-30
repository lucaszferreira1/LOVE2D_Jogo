Placeable = require("utils.objects.placeable")

local placeables = {
    ["Saw"] = Placeable:new(1, "Saw", "Machines", "A tool for cutting wood materials.", -1, -1, "none", 1, 1, "assets/items/placeables/saw.png", "assets/items/placeables/saw.png", 0.07),
    ["Drill"] = Placeable:new(2, "Drill", "Machines", "A tool for drilling holes.", -1, -1, "none", 1, 1, "assets/items/placeables/drill.png", "assets/items/placeables/drill.png", 0.07),
    ["Cutter"] = Placeable:new(3, "Cutter", "Machines", "A tool for cutting cloth materials.", -1, -1, "none", 1, 1, "assets/items/placeables/cutter.png", "assets/items/placeables/cutter.png", 0.07),
}

function placeables.getPlaceables()
    return placeables
end

function placeables.getPlaceableByName(name)
    return placeables[name]
end

return placeables