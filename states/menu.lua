local StateManager = require("utils.state_manager")
local Fade = require("ui.fade")
local Button = require("ui.button")

local Menu = {}

local buttons = {}

function Menu:enter()
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    local centerX = screenW / 2 - 100
    local startY = 200
    local spacing = 70

    buttons = {
        Button:new("Start Game", centerX, startY, 200, 50, function()
            Fade:start(0.5, function()
                local LevelSelect = require("states.level_select")
                StateManager:switch(LevelSelect)
            end)
        end, {
            color = {0.2, 0.6, 0.2},
            hoverColor = {0.3, 0.8, 0.3},
            textColor = {1, 1, 1}
        }),

        Button:new("Options", centerX, startY + spacing, 200, 50, function()
            Fade:start(0.5, function()
                local Options = require("states.options")
                StateManager:switch(Options)
            end)
        end, {
            color = {0.2, 0.4, 0.6},
            hoverColor = {0.4, 0.6, 0.8},
            textColor = {1, 1, 1}
        }),

        Button:new("Quit", centerX, startY + spacing * 2, 200, 50, function()
            love.event.quit()
        end, {
            color = {0.6, 0.2, 0.2},
            hoverColor = {0.8, 0.3, 0.3},
            textColor = {1, 1, 1}
        })
    }
end

function Menu:update(dt)
    for _, btn in ipairs(buttons) do
        btn:update(dt)
    end
end

function Menu:draw()
    local background = love.graphics.newImage("assets/backgrounds/main.png")
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Factory Game", 0, 100, love.graphics.getWidth(), "center")

    for _, btn in ipairs(buttons) do
        btn:draw()
    end
end

function Menu:mousepressed(x, y, button)
    for _, btn in ipairs(buttons) do
        btn:mousepressed(x, y, button)    
    end
end

return Menu
