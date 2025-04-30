-- Gameplay.lua
local StateManager = require("utils.state_manager")

local Gameplay = {}

function Gameplay:enter(level_id)
    self.level = level_id
    local levels = require("utils.lists.levels")
    self.level_data = levels.getLevel(level_id)
    self.size = 30
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    local Grid = require("utils.grid")
    self.grid = Grid:new(self.level_data.width, self.level_data.height, self.level_data.itemsIn, self.level_data.itemsOut)

    -- setup buttons
    self.placeableButtons = {}
    for _, placeable in ipairs(self.level_data.placeables) do
        local PlaceableButton = require("ui.placeable_button")
        local button = PlaceableButton:new(0, 0, self.size * 2, self.size * 2, placeable)
        table.insert(self.placeableButtons, button)
    end

    -- dragging state
    self.dragging = nil  -- { placeable, x, y }
end

function Gameplay:update(dt)
    local mx, my = love.mouse.getPosition()

    -- update hover state of buttons
    for _, button in ipairs(self.placeableButtons) do
        button:update(mx, my)
    end

    -- update dragging position
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

    love.graphics.setColor(1, 1, 1, 1)
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

    -- draw already placed items from grid
    for x = 1, self.level_data.width do
        for y = 1, self.level_data.height do
            local placeable = self.grid:getPlaceable(x, y)
            if placeable then
                local drawX = self.gridStartX + (x-1) * self.size
                local drawY = self.gridStartY + (y-1) * self.size
                love.graphics.setColor(1, 1, 1, 1)
                if placeable.drawIcon then
                    placeable:drawIcon(drawX, drawY)
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

-- new: draw preview of dragging placeable, snapped to grid
function Gameplay:drawDraggingPreview()
    local mx, my = self.dragging.x, self.dragging.y
    -- calculate grid cell
    local col = math.floor((mx - self.gridStartX) / self.size)
    local row = math.floor((my - self.gridStartY) / self.size)
    -- snap back into bounds
    col = math.max(0, math.min(col, self.level_data.width - 1))
    row = math.max(0, math.min(row, self.level_data.height - 1))
    local drawX = self.gridStartX + col * self.size
    local drawY = self.gridStartY + row * self.size

    love.graphics.setColor(1, 1, 1, 0.7)
    -- draw a rectangle background
    love.graphics.rectangle("fill", drawX, drawY, self.size, self.size)
    -- draw the actual icon if available
    if self.dragging.placeable.drawIcon then
        self.dragging.placeable:drawIcon(drawX, drawY)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

-- new: pick up on mouse press
function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        -- check buttons
        if not self.dragging then
            for _, btn in ipairs(self.placeableButtons) do
                if btn:isHoveredAt(x, y) then
                    -- start dragging
                    self.dragging = { placeable = btn.placeable, x = x, y = y }
                    return
                end
            end
        else
            local col0 = math.floor((x - self.gridStartX) / self.size)
            local row0 = math.floor((y - self.gridStartY) / self.size)
            -- clamp to valid
            local cx = math.max(0, math.min(col0, self.level_data.width - 1))
            local cy = math.max(0, math.min(row0, self.level_data.height - 1))
            -- add to grid (Lua grids are 1-based)
            self.grid:addPlaceable(cx+1, cy+1, self.dragging.placeable)

            -- stop dragging
            self.dragging = nil
        end
    end
    if button == 2 then
        if self.dragging then
            local col0 = math.floor((x - self.gridStartX) / self.size)
            local row0 = math.floor((y - self.gridStartY) / self.size)
            -- clamp to valid
            local cx = math.max(0, math.min(col0, self.level_data.width - 1))
            local cy = math.max(0, math.min(row0, self.level_data.height - 1))
            -- add to grid (Lua grids are 1-based)
            self.grid:addPlaceable(cx+1, cy+1, self.dragging.placeable)
        end
    end
end


function Gameplay:keypressed(key)
    if key == "b" then
        local LevelSelect = require("states.level_select")
        StateManager:switch(LevelSelect)
    end
end

return Gameplay