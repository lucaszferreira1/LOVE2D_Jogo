-- Define the Recipe class
local Recipe = {}
Recipe.__index = Recipe

-- Constructor
function Recipe:new(itemsIn, itemsOut)
    local instance = setmetatable({}, Recipe)
    instance.itemsIn = itemsIn or {} -- List of input items with quantities
    instance.itemsOut = itemsOut or {} -- List of output items with quantities
    return instance
end

-- Method to add an input item
function Recipe:addInputItem(item, quantity)
    self.itemsIn[item] = (self.itemsIn[item] or 0) + quantity
end

-- Method to add an output item
function Recipe:addOutputItem(item, quantity)
    self.itemsOut[item] = (self.itemsOut[item] or 0) + quantity
end

return Recipe