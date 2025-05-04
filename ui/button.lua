local Button = {}
Button.__index = Button

local lerp = function(a, b, t) return a + (b - a) * t end

function Button:new(text, x, y, width, height, onClick, options)
    options = options or {}
    local self = setmetatable({
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        onClick = onClick,
        hovered = false,
        font = options.font or love.graphics.getFont(),
        baseColor = options.color or {0.5, 0.5, 0.9},
        baseHoverColor = options.hoverColor or {0.7, 0.7, 1.0},
        textColor = options.textColor or {1, 1, 1},
        color = {0.5, 0.5, 0.9}, -- animated color
        hoverScale = options.hoverScale or 1.05,
        currentScale = 1
    }, Button)
    return self
end

function Button:setXYWH(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Button:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function Button:draw()
    love.graphics.setColor(self.color)
    local scale = self.currentScale
    local ox = (self.width * scale - self.width) / 2
    local oy = (self.height * scale - self.height) / 2
    love.graphics.rectangle("fill", self.x - ox, self.y - oy, self.width * scale, self.height * scale, 8, 8)

    love.graphics.setColor(self.textColor)
    love.graphics.setFont(self.font)

    local textW = self.font:getWidth(self.text)
    local textH = self.font:getHeight()
    love.graphics.print(
        self.text,
        self.x + (self.width - textW) / 2,
        self.y + (self.height - textH) / 2
    )
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.hovered = self:isHovered(mx, my)

    -- Smooth color transition
    local target = self.hovered and self.baseHoverColor or self.baseColor
    for i = 1, 3 do
        self.color[i] = lerp(self.color[i], target[i], dt * 10)
    end

    -- Smooth scale transition
    local targetScale = self.hovered and self.hoverScale or 1
    self.currentScale = lerp(self.currentScale, targetScale, dt * 10)
end

function Button:mousepressed(x, y, button)
    if button == 1 and self:isHovered(x, y) and self.onClick then
        love.audio.newSource("assets/sounds/click.wav", "static"):play()
        self.onClick()
    end
end

return Button
