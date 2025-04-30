-- levels.lua
Level = require("utils.level")
items = require("utils.lists.items")
placeables = require("utils.lists.placeables")

local levels = {}

local level1 = Level:new(1, 10, 10, "First level description")
level1:addItemIn(items.getItemByName("Iron Ingot"), {x = 1, y = 1}, 10)
level1:addItemOut(items.getItemByName("Iron Ingot"), {x = 10, y = 10}, 10)
level1:addPlaceable(placeables.getPlaceableByName("Saw"))
level1:addPlaceable(placeables.getPlaceableByName("Saw"))
level1:addPlaceable(placeables.getPlaceableByName("Saw"))
table.insert(levels, level1)

local levelMethods = {}

function levelMethods.getLevels()
    return levels
end

function levelMethods.getLevel(id)
    for _, level in ipairs(levels) do
        if level.id == id then
            return level
        end
    end
    return nil
end

return levelMethods
