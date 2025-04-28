-- Define the Item class
local Item = {}
Item.__index = Item

function Item:new(id, name, category, description, iconPath, scale)
    local instance = setmetatable({}, Item)
    instance.id = id or 0
    instance.name = name or "Unknown Item"
    instance.description = description or "No description available."
    instance.category = category or "items"
    instance.icon = love.graphics.newImage(iconPath or "default_icon.png")
    instance.scale = scale or 1
    return instance
end

function Item:draw(x, y)
    if self.icon then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.icon, x, y, 0, self.scale, self.scale)
    end
end

return Item