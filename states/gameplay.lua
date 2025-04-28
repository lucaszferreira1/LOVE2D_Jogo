local StateManager = require("utils.state_manager")

local Gameplay = {}

function Gameplay:enter(level_id)
    self.level = level_id
    local levels = require("utils.lists.levels")
    self.level_data = levels.getLevel(level_id)
    self.size = 25
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    self.placeableButtons = {}
    for _, placeable in ipairs(self.level_data.placeables) do
        local PlaceableButton = require("ui.placeable_button")
        local button = PlaceableButton:new(0, 0, self.size * 2, self.size * 2, placeable)
        table.insert(self.placeableButtons, button)
    end

end

function Gameplay:update(dt)
    local mx, my = love.mouse.getPosition()

    for _, button in ipairs(self.placeableButtons) do
        button:update(mx, my)
    end
end

function Gameplay:draw()
    self:drawPlaceables()
    self:drawGrid()
    love.graphics.printf("Playing Level " .. tostring(self.level), 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("[B] Return to Level Selection", 0, 550, love.graphics.getWidth(), "center")
end

function Gameplay:drawPlaceables()
    local placeables = self.level_data:getPlaceables()
    local gridHeight = self.size * self.level_data.height
    local padding = 10
    local columns = 2
    local buttonWidth = self.size * 2
    local buttonHeight = self.size * 2
    local totalHeight = math.ceil(#self.placeableButtons / columns) * (buttonHeight + padding) - padding
    local startX = 20
    local startY = (self.screenHeight - totalHeight) / 2

    love.graphics.setColor(1, 1, 1, 1)

    for i, button in ipairs(self.placeableButtons) do
        local column = (i - 1) % columns
        local row = math.floor((i - 1) / columns)
        local x = startX + column * (buttonWidth + padding)
        local y = startY + row * (buttonHeight + padding)
        button.x = x
        button.y = y
        button:draw()
    end
end



function Gameplay:drawGrid()
    local gridWidth = self.size * self.level_data.width
    local gridHeight = self.size * self.level_data.height
    local startX = (self.screenWidth - gridWidth) / 2
    local startY = (self.screenHeight - gridHeight) / 2

    love.graphics.setColor(1, 1, 1, 0.5)
    for i = 0, self.level_data.width do
        -- Draw vertical lines
        love.graphics.line(startX + i * self.size, startY, startX + i * self.size, startY + gridHeight)
        -- Draw horizontal lines
        love.graphics.line(startX, startY + i * self.size, startX + gridWidth, startY + i * self.size)
    end

    
    for _, item in ipairs(self.level_data:getItemsIn()) do
        love.graphics.setColor(0, 1, 0, 0.7)
        love.graphics.rectangle("fill", startX + item.position.x * self.size, startY + item.position.y * self.size, self.size, self.size)
        item.item:draw(startX + item.position.x * self.size, startY + item.position.y * self.size)
    end

    for _, item in ipairs(self.level_data:getItemsOut()) do
        love.graphics.setColor(1, 0, 0, 0.7)
        love.graphics.rectangle("fill", startX + item.position.x * self.size, startY + item.position.y * self.size, self.size, self.size)
        item.item:draw(startX + item.position.x * self.size, startY + item.position.y * self.size)
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
