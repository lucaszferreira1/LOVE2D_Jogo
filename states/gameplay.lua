-- Gameplay.lua
local StateManager = require("utils.state_manager")

local Gameplay = {}

function Gameplay:enter(level_id, level_data, grid)
    self.level = level_id
    local levels = require("utils.lists.levels")
    if level_data then
        self.level_data = level_data
    else
        self.level_data = levels.getLevel(level_id)
    end
    self.size = 30
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    if grid then
        self.grid = grid
    else
        local Grid = require("utils.grid")
        self.grid = Grid:new(self.level_data.width, self.level_data.height, self.level_data.itemsIn, self.level_data.itemsOut)
    end
    
    local Button = require("ui.button")
    local Fade = require("ui.fade")
    self.electricalButton = Button:new("Electrical", 1, 1, 1, 1, function()
        Fade:start(0.5, function()
            local Electrical_Gameplay = require("states.electrical_gameplay")
            StateManager:switchElectrical(Electrical_Gameplay, self.level, self.level_data, self.grid)
        end)
    end, {
        color = {0.5, 0.5, 0.5},
        hoverColor = {0.4, 0.6, 0.8},
        textColor = {1, 1, 1}
    })


    self.placeableButtons = {}
    for _, placeable in ipairs(self.level_data.placeables) do
        local PlaceableButton = require("ui.placeable_button")
        local button = PlaceableButton:new(0, 0, self.size * 2, self.size * 2, placeable)
        table.insert(self.placeableButtons, button)
    end

    self.dragging = nil  -- { placeable, x, y }
end

function Gameplay:update(dt)
    local mx, my = love.mouse.getPosition()

    self.electricalButton:update(dt)

    for _, button in ipairs(self.placeableButtons) do
        button:update(mx, my)
    end

    if self.dragging then
        self.dragging.x = mx
        self.dragging.y = my
    end
end

function Gameplay:draw()
    -- draw grid and placed items
    self:drawGrid()
    -- draw UI text
    love.graphics.printf("Playing Level " .. tostring(self.level), 0, 50, self.screenWidth, "center")
    love.graphics.printf("[B] Return to Level Selection", 0, 550, self.screenWidth, "center")

    -- draw placeable buttons
    self:drawPlaceables()
    -- draw descriptions on hover
    self:drawDescriptions()

    -- draw dragging preview if any
    if self.dragging then
        self:drawDraggingPreview()
    end
end

function Gameplay:drawPlaceables()
    local padding = self.size * 0.4
    local columns = 3
    local buttonWidth = self.size * 2
    local buttonHeight = self.size * 2
    local totalHeight = math.ceil(#self.placeableButtons / columns) * (buttonHeight + padding) - padding
    local startX = self.size * 0.66
    local startY = (self.screenHeight - totalHeight) / 2

    -- Draw the box containing the placeable buttons
    local boxWidth = columns * (buttonWidth + padding) - padding
    local boxHeight = totalHeight + buttonHeight + padding * 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", startX - padding, startY - padding, boxWidth + padding * 2, boxHeight)
    love.graphics.setColor(1, 1, 1, 1)

    -- Adjust button dimensions to be half the width of the box
    local topButtonWidth = (boxWidth + padding * 2) / 2 - padding

    -- Draw the "Mechanical" fake button
    local mechanicalButtonX = startX - padding
    local mechanicalButtonY = startY - padding - buttonHeight - padding
    love.graphics.setColor(0.5, 0.5, 0.9, 1)
    love.graphics.rectangle("fill", mechanicalButtonX, mechanicalButtonY, topButtonWidth, buttonHeight, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Mechanical", mechanicalButtonX, mechanicalButtonY + (buttonHeight - love.graphics.getFont():getHeight()) / 2, topButtonWidth, "center")

    local electricalButtonX = mechanicalButtonX + topButtonWidth + padding * 2
    self.electricalButton:setXYWH(electricalButtonX, mechanicalButtonY, topButtonWidth, buttonHeight)
    self.electricalButton:draw()

    -- Draw the placeable buttons
    for i, button in ipairs(self.placeableButtons) do
        local col = (i - 1) % columns
        local row = math.floor((i - 1) / columns)
        local x = startX + col * (buttonWidth + padding)
        local y = startY + row * (buttonHeight + padding)
        button.x = x
        button.y = y
        button:draw()
    end
end

function Gameplay:drawGrid()
    local gridWidth = self.size * self.level_data.width
    local gridHeight = self.size * self.level_data.height
    self.gridStartX = (self.screenWidth - gridWidth) / 2
    self.gridStartY = (self.screenHeight - gridHeight) / 2

    love.graphics.setColor(1, 1, 1, 0.5)
    for i = 0, self.level_data.width do
        love.graphics.line(self.gridStartX + i * self.size, self.gridStartY, self.gridStartX + i * self.size, self.gridStartY + gridHeight)
        love.graphics.line(self.gridStartX, self.gridStartY + i * self.size, self.gridStartX + gridWidth, self.gridStartY + i * self.size)
    end

    
    for _, item in ipairs(self.level_data:getItemsIn()) do
        love.graphics.setColor(0, 1, 0, 0.7)
        love.graphics.rectangle("fill", self.gridStartX + (item.position.x - 1) * self.size, self.gridStartY + (item.position.y - 1) * self.size, self.size, self.size)
        item.item:draw(self.gridStartX + (item.position.x - 1) * self.size, self.gridStartY + (item.position.y - 1) * self.size)
    end

    for _, item in ipairs(self.level_data:getItemsOut()) do
        love.graphics.setColor(1, 0, 0, 0.7)
        love.graphics.rectangle("fill", self.gridStartX + (item.position.x - 1) * self.size, self.gridStartY + (item.position.y - 1) * self.size, self.size, self.size)
        item.item:draw(self.gridStartX + (item.position.x - 1) * self.size, self.gridStartY + (item.position.y - 1) * self.size)
    end

    -- draw placed items from grid
    for x = 1, self.level_data.width do
        for y = 1, self.level_data.height do
            local placeable = self.grid:getPlaceable(x, y)
            if placeable then
                local drawX = self.gridStartX + (x-1) * self.size
                local drawY = self.gridStartY + (y-1) * self.size
                love.graphics.setColor(1, 1, 1, 1)
                if placeable.icon then
                    placeable:drawSprite(drawX, drawY)
                end
            end
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function Gameplay:drawDescriptions()
    for _, button in ipairs(self.placeableButtons) do
        button:drawDescriptionHover()
    end
end

function Gameplay:drawDraggingPreview()
    local mx, my = self.dragging.x, self.dragging.y
    local col = math.floor((mx - self.gridStartX) / self.size)
    local row = math.floor((my - self.gridStartY) / self.size)
    col = math.max(0, math.min(col, self.level_data.width - 1))
    row = math.max(0, math.min(row, self.level_data.height - 1))
    local drawX = self.gridStartX + col * self.size
    local drawY = self.gridStartY + row * self.size

    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.rectangle("fill", drawX, drawY, self.size, self.size)
    if self.dragging.placeable.drawIcon then
        self.dragging.placeable:drawIcon(drawX, drawY)
    end
    
    -- draw an arrow indicating the direction the placeable is pointing
    if self.dragging.placeable.direction then
        local arrowSize = self.size * 0.5
        local centerX = drawX + self.size / 2
        local centerY = drawY + self.size / 2
        local dx, dy = 0, 0

        if self.dragging.placeable.direction == "up" then
            dx, dy = 0, -arrowSize
        elseif self.dragging.placeable.direction == "down" then
            dx, dy = 0, arrowSize
        elseif self.dragging.placeable.direction == "left" then
            dx, dy = -arrowSize, 0
        elseif self.dragging.placeable.direction == "right" then
            dx, dy = arrowSize, 0
        end
        if not self.dragging.placeable.direction == "none" then
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.line(centerX, centerY, centerX + dx, centerY + dy)
            love.graphics.circle("fill", centerX + dx, centerY + dy, arrowSize * 0.2)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end


function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        if self.electricalButton:isHovered(x, y) then
            self.electricalButton:mousepressed(x, y, button)
            return
        end

        for _, btn in ipairs(self.placeableButtons) do
            if btn:isHoveredAt(x, y) then
                self.dragging = { placeable = btn.placeable, x = x, y = y }
                return
            end
        end
        
        if self.dragging then
            local col0 = math.floor((x - self.gridStartX) / self.size)
            local row0 = math.floor((y - self.gridStartY) / self.size)
            local cx = math.max(0, math.min(col0, self.level_data.width - 1))
            local cy = math.max(0, math.min(row0, self.level_data.height - 1))
            self.grid:addPlaceable(cx+1, cy+1, self.dragging.placeable)

            self.dragging = nil
        end
        
    elseif button == 2 then
        if self.dragging then
            local col0 = math.floor((x - self.gridStartX) / self.size)
            local row0 = math.floor((y - self.gridStartY) / self.size)
            local cx = math.max(0, math.min(col0, self.level_data.width - 1))
            local cy = math.max(0, math.min(row0, self.level_data.height - 1))
            self.grid:addPlaceable(cx+1, cy+1, self.dragging.placeable)
        end
    end
end


function Gameplay:keypressed(key)
    if key == "b" then
        local LevelSelect = require("states.level_select")
        StateManager:switch(LevelSelect)
    elseif key == "r" then
        if self.dragging then 
            self.dragging.placeable:rotate()
        end
    end
end

return Gameplay