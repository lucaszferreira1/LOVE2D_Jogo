-- Gameplay.lua
local StateManager = require("utils.state_manager")

local Gameplay = {}

function Gameplay:enter(level_id, level_data, grid)
    self.level = level_id
    self.level_data = level_data
    self.size = 30
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    local Grid = require("utils.grid")
    self.grid = grid

    local Button = require("ui.button")
    local Fade = require("ui.fade")
    self.mechanicalButton = Button:new("Mechanical", 1, 1, 1, 1, function()
        Fade:start(0.5, function()
            local Gameplay = require("states.gameplay")
            StateManager:switchElectrical(Gameplay, self.level, self.level_data, self.grid)
        end)
    end, {
        color = {0.5, 0.5, 0.5},
        hoverColor = {0.4, 0.6, 0.8},
        textColor = {1, 1, 1}
    })

    self.functionBlocks = grid.functionBlocks
end

function Gameplay:update(dt)
    local mx, my = love.mouse.getPosition()

    self.mechanicalButton:update(dt)
end

function Gameplay:draw()
    love.graphics.printf("Playing Level " .. tostring(self.level), 0, 50, self.screenWidth, "center")
    love.graphics.printf("[B] Return to Grid View", 0, 550, self.screenWidth, "center")

    self:drawPlaceables()

end

function Gameplay:drawPlaceables()
    local padding = self.size * 0.4
    local columns = 3
    local buttonWidth = self.size * 2
    local buttonHeight = self.size * 2
    local totalHeight = math.ceil(#self.functionBlocks / columns) * (buttonHeight + padding) - padding
    local startX = self.size * 0.66
    local startY = (self.screenHeight - totalHeight) / 2

    -- Draw the box containing the placeable buttons
    local boxWidth = columns * (buttonWidth + padding) - padding
    local boxHeight = totalHeight + buttonHeight + padding * 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", startX - padding, startY - padding, boxWidth + padding * 2, boxHeight)
    love.graphics.setColor(1, 1, 1, 1)

    local topButtonWidth = (boxWidth + padding * 2) / 2 - padding

    local mechanicalButtonX = startX - padding
    local mechanicalButtonY = startY - padding - buttonHeight - padding
    self.mechanicalButton:setXYWH(mechanicalButtonX, mechanicalButtonY, topButtonWidth, buttonHeight)
    self.mechanicalButton:draw()

    local electricalButtonX = mechanicalButtonX + topButtonWidth + padding * 2
    love.graphics.setColor(0.5, 0.5, 0.9, 1)
    love.graphics.rectangle("fill", electricalButtonX, mechanicalButtonY, topButtonWidth, buttonHeight, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Electrical", electricalButtonX, mechanicalButtonY + (buttonHeight - love.graphics.getFont():getHeight()) / 2, topButtonWidth, "center")

end


function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        self.mechanicalButton:mousepressed(x, y, button)
    end
end


function Gameplay:keypressed(key)
    if key == "b" then
        local Gameplay = require("states.Gameplay")
        StateManager:switchElectrical(Gameplay, self.level, self.level_data, self.grid)
    end
end

return Gameplay