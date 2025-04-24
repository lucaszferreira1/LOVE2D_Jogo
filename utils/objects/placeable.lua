-- Placeable.lua
local Placeable = {}
Placeable.__index = Placeable

function Placeable:new(name, x, y, direction, width, height, sprite)
    local instance = setmetatable({}, Placeable)
    instance.name = name or "Unnamed"
    instance.x = x or -1
    instance.y = y or -1
    instance.direction = direction or "right"
    instance.width = width or 1
    instance.height = height or 1
    instance.sprite = sprite or nil
    return instance
end

function Placeable:getPosition()
    return self.x, self.y
end

function Placeable:setPosition(x, y)
    self.x = x
    self.y = y
end

function Placeable:getDirection()
    return self.direction
end

function Placeable:setDirection(direction)
    self.direction = direction
end

function Placeable:getSize()
    return self.width, self.height
end

function Placeable:setSize(width, height)
    self.width = width
    self.height = height
end

function Placeable:getSprite()
    return self.sprite
end

function Placeable:setSprite(sprite)
    self.sprite = sprite
end

function Placeable:draw()
    if self.sprite then
        love.graphics.draw(self.sprite, self.x, self.y, math.rad(self.direction), self.width, self.height)
    else
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
end

return Placeable