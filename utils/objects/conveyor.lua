-- conveyor.lua
local Placeable = require("utils.objects.placeable") -- Adjust the path as needed

local Conveyor = Placeable:extend()

function Conveyor:new(x, y, direction, sprite)
    Conveyor.super.new(self, "Conveyor Belt", x, y, direction, 1, 1, sprite)
    self.item = nil
end

function Conveyor:addItem(item)
    self.item = item
end

function Conveyor:hasItem()
    return self.item ~= nil
end

function moveItem(self, grid)
    if self:hasItem() then
        nextConveyor = self:getNextConveyor(grid)
        if nextConveyor and nextConveyor:hasItem() == false then
            nextConveyor:addItem(self.item)
            self.item = nil
        end
    end
end

function Conveyor:getNextConveyor(grid)
    if self.direction == "up" then
        return self.grid:getConveyorAt(self.x, self.y - 1)
    elseif self.direction == "down" then
        return self.grid:getConveyorAt(self.x, self.y + 1)
    elseif self.direction == "left" then
        return self.grid:getConveyorAt(self.x - 1, self.y)
    elseif self.direction == "right" then
        return self.grid:getConveyorAt(self.x + 1, self.y)
    end
    return nil
end

function Conveyor:playAnimation()
    -- Logic to play conveyor animation
end

function Conveyor:update(dt)
    self:moveItem(dt)
    self:playAnimation()
end

function Conveyor:draw()
    -- Logic to draw the conveyor
end

return Conveyor
