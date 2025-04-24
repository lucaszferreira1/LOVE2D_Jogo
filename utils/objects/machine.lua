local Placeable = require("utils.placeable")
local Recipe = require("utils.items.recipe")

local Machine = Placeable:extend()

function Machine:new(name, x, y, width, height, sprite)
    Machine.super.new(self, name, x, y, width, height, sprite)
    self.recipes = {}
end

function Machine:addRecipe(recipe)
    table.insert(self.recipes, recipe)
end

function Machine:getRecipes()
    return self.recipes
end

return Machine