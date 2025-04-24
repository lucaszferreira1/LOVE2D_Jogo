-- container.lua
local Placeable = require("utils.objects.placeable")

local Container = Placeable:extend()

function Container:new(name, x, y, width, height, capacity, sprite)
    Container.super.new(self, x, y, 0, width, height, sprite)
    self.capacity = capacity or 1
    self.items = {} 
end

function Container:addItem(item)
    if #self.items < self.capacity then
        table.insert(self.items, item)
        return true
    else
        return false
    end
end

function Container:removeItem(item)
    for i, storedItem in ipairs(self.items) do
        if storedItem == item then
            table.remove(self.items, i)
            return true
        end
    end
    return false
end

function Container:getItems()
    return self.items
end

function Container:isFull()
    return #self.items >= self.capacity
end

return Container