-- PlaceableButton.lua
local PlaceableButton = {}
PlaceableButton.__index = PlaceableButton

function PlaceableButton:new(x, y, width, height, placeable)
    local self = setmetatable({}, PlaceableButton)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.placeable = placeable
    self.isHovered = false
    return self
end

function PlaceableButton:update(mx, my)
    self.isHovered = mx >= self.x and mx <= self.x + self.width
                      and my >= self.y and my <= self.y + self.height
end

function PlaceableButton:isHoveredAt(px, py)
    return px >= self.x and px <= self.x + self.width
       and py >= self.y and py <= self.y + self.height
end

function PlaceableButton:draw()
    if not self.isHovered then
        love.graphics.setColor(0.2, 0.2, 0.2)
    else
        love.graphics.setColor(0.3, 0.3, 0.3)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)

    if self.placeable.icon then
        local iconX = self.x + self.width / 4
        local iconY = self.y + self.height / 8
        self.placeable:drawIcon(iconX, iconY)
    end

    love.graphics.setColor(1, 1, 1)
    local textX = self.x + (self.width / 2)
    local textY = self.y + self.height / 1.5
    love.graphics.printf(self.placeable.name, textX - self.width / 2, textY, self.width, "center")
end

function PlaceableButton:drawDescriptionHover()
    if self.isHovered then
        local descriptionWidth = self.width * 4
        local descriptionHeight = self.height
        local descriptionX = self.x + self.width + self.width * 0.2
        local descriptionY = self.y

        love.graphics.setColor(0.9, 0.9, 0.9)
        love.graphics.rectangle("fill", descriptionX, descriptionY, descriptionWidth, descriptionHeight, 10, 10)

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(self.placeable.description,
        descriptionX + self.width * 0.1,
        descriptionY + self.height * 0.1,
        descriptionWidth - self.width * 0.2, "left")
    end
end

return PlaceableButton