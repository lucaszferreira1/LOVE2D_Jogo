local StateManager = require("utils.state_manager")

local Gameplay = {}

function Gameplay:enter(level_id)
    self.level = level_id
    local levels = require("utils.lists.levels")
    self.level_data = levels.getLevel(level_id)
end

function Gameplay:update(dt)
    -- Update level logic: move enemies, check for player input, etc.
end

function Gameplay:draw()
    self:drawGrid()
    love.graphics.printf("Playing Level " .. tostring(self.level), 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("[B] Return to Level Selection", 0, 550, love.graphics.getWidth(), "center")
end

function Gameplay:drawGrid()
    local gridSize = 25
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local gridWidth = gridSize * self.level_data.width
    local gridHeight = gridSize * self.level_data.height
    local startX = (screenWidth - gridWidth) / 2
    local startY = (screenHeight - gridHeight) / 2

    love.graphics.setColor(1, 1, 1, 0.5)
    for i = 0, self.level_data.width do
        -- Draw vertical lines
        love.graphics.line(startX + i * gridSize, startY, startX + i * gridSize, startY + gridHeight)
        -- Draw horizontal lines
        love.graphics.line(startX, startY + i * gridSize, startX + gridWidth, startY + i * gridSize)
    end

    
    for _, item in ipairs(self.level_data:getItemsIn()) do
        love.graphics.setColor(0, 1, 0, 0.7) -- Green for items in
        love.graphics.rectangle("fill", startX + item.position.x * gridSize, startY + item.position.y * gridSize, gridSize, gridSize)
        item.item:draw(startX + item.position.x * gridSize, startY + item.position.y * gridSize)
    end

    for _, item in ipairs(self.level_data:getItemsOut()) do
        love.graphics.setColor(1, 0, 0, 0.7) -- Softer red for items out
        love.graphics.rectangle("fill", startX + item.position.x * gridSize, startY + item.position.y * gridSize, gridSize, gridSize)
        item.item:draw(startX + item.position.x * gridSize, startY + item.position.y * gridSize)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function Gameplay:keypressed(key)
    if key == "b" then
        local LevelSelect = require("states.level_select")
        StateManager:switch(LevelSelect)
    end
end

return Gameplay
