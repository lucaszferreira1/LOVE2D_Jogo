-- Placeable.lua
local Placeable = {}
Placeable.__index = Placeable

function Placeable:new(id, name, category, description, x, y, direction, width, height, iconPath, sprite, scale)
    local instance = setmetatable({}, Placeable)
    instance.id = id or 0
    instance.name = name or "Unknown Placeable"
    instance.category = category or "placeables"
    instance.description = description or "No description available."
    instance.x = x or -1
    instance.y = y or -1
    instance.direction = direction or "none"
    instance.width = width or 1
    instance.height = height or 1
    instance.icon = love.graphics.newImage(iconPath or "default_icon.png")
    instance.sprite = love.graphics.newImage(sprite or "default_placeable.png")
    instance.scale = scale or 1
    return instance
end

function Placeable:getId()
    return self.id
end

function Placeable:setId(id)
    self.id = id
end

function Placeable:getName()
    return self.name
end

function Placeable:setName(name)
    self.name = name
end

function Placeable:getCategory()
    return self.category
end

function Placeable:setCategory(category)
    self.category = category
end

function Placeable:getDescription()
    return self.description
end

function Placeable:setDescription(description)
    self.description = description
end

function Placeable:getX()
    return self.x
end

function Placeable:setX(x)
    self.x = x
end

function Placeable:getY()
    return self.y
end

function Placeable:setY(y)
    self.y = y
end

function Placeable:getDirection()
    return self.direction
end

function Placeable:setDirection(direction)
    self.direction = direction
end

function Placeable:getWidth()
    return self.width
end

function Placeable:setWidth(width)
    self.width = width
end

function Placeable:getHeight()
    return self.height
end

function Placeable:setHeight(height)
    self.height = height
end

function Placeable:getSprite()
    return self.sprite
end

function Placeable:setSprite(sprite)
    self.sprite = love.graphics.newImage(sprite)
end

function Placeable:getIcon()
    return self.icon
end

function Placeable:setIcon(iconPath)
    self.icon = love.graphics.newImage(iconPath)
end

function Placeable:getScale()
    return self.scale
end

function Placeable:setScale(scale)
    self.scale = scale
end

function Placeable:rotate()
    if self.direction == "up" then
        self.direction = "right"
    elseif self.direction == "right" then
        self.direction = "down"
    elseif self.direction == "down" then
        self.direction = "left"
    elseif self.direction == "left" then
        self.direction = "up"
    end
end

function Placeable:drawIcon(x, y)
    x = x or self.x
    y = y or self.y
    if self.icon then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.icon, x, y, 0, self.scale, self.scale)
    end
end

function Placeable:drawSprite(x, y)
    if self.sprite then
        love.graphics.draw(self.sprite, x, y, 0, self.scale, self.scale)
    else
        love.graphics.rectangle("line", x, y, self.width, self.height)
    end
end

return Placeable