local PlaceableButton = {}
PlaceableButton.__index = PlaceableButton

function PlaceableButton:new(x, y, width, height, placeable)
    local self = setmetatable({}, PlaceableButton)
    self.width = width
    self.height = height
    self.placeable = placeable
    self.isHovered = false
    return self
end

function PlaceableButton:draw()
    local twentyPWidth = self.width * 0.2
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    if self.placeable.icon then
        local iconX = self.x + self.width / 4
        local iconY = self.y + self.height / 8
        self.placeable:drawIcon(iconX, iconY)
    end

    love.graphics.setColor(1, 1, 1)
    local textX = self.x + (self.width / 2)
    local textY = self.y + self.height / 1.5
    love.graphics.printf(self.placeable.name, textX - self.width / 2, textY, self.width, "center")

    if self.isHovered then
        local descriptionWidth = self.width * 4
        local descriptionHeight = self.height
        local descriptionX = self.x + self.width + twentyPWidth
        local descriptionY = self.y

        love.graphics.setColor(0.9, 0.9, 0.9)
        love.graphics.rectangle("fill", descriptionX, descriptionY, descriptionWidth, descriptionHeight, 10, 10)

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(self.placeable.description, descriptionX + 5, descriptionY + 5, descriptionWidth - twentyPWidth, "left")
    end
end

function PlaceableButton:update(mx, my)
    self.isHovered = mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

return PlaceableButton