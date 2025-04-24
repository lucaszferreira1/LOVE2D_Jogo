local StateManager = require("utils.state_manager")
local Fade = require("ui.fade")
local Button = require("ui.button")

local LevelSelect = {}

local buttons = {}

local levels = {
    "Level 1"
}

local columns = 3 -- Number of buttons per row
local rows = math.ceil(#levels / columns) -- Auto-calculate rows based on levels

function LevelSelect:enter()
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    local buttonWidth = 200
    local buttonHeight = 50
    local padding = 20
    local startX = screenW / 2 - (buttonWidth * columns + padding * (columns - 1)) / 2
    local startY = 200

    -- Create buttons for each level in a 3x3 grid
    buttons = {}

    for i, level in ipairs(levels) do
        local row = math.floor((i - 1) / columns) -- Calculate the row based on the index
        local col = (i - 1) % columns           -- Calculate the column based on the index

        local x = startX + col * (buttonWidth + padding)
        local y = startY + row * (buttonHeight + padding)

        -- Create a button for each level
        table.insert(buttons, Button:new(level, x, y, buttonWidth, buttonHeight, function()
            Fade:start(0.5, function()
                local Gameplay = require("states.gameplay")
                StateManager:switchToLevel(Gameplay, i)
            end)
        end, {
            color = {0.2, 0.4, 0.6},
            hoverColor = {0.4, 0.6, 0.8},
            textColor = {1, 1, 1}
        }))
    end

    -- Add "Back to Menu" button
    table.insert(buttons, Button:new("Back to Menu", screenW / 2 - 100, startY + rows * (buttonHeight + padding), 200, 50, function()
        Fade:start(0.5, function()
            local Menu = require("states.menu")
            StateManager:switch(Menu)
        end)
    end, {
        color = {0.6, 0.2, 0.2},
        hoverColor = {0.8, 0.3, 0.3},
        textColor = {1, 1, 1}
    }))
end

function LevelSelect:update(dt)
    for _, btn in ipairs(buttons) do
        btn:update(dt)
    end
end

function LevelSelect:draw()
    local background = love.graphics.newImage("assets/backgrounds/level_select.png")
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Select a Level", 0, 100, love.graphics.getWidth(), "center")

    -- Draw each button
    for _, btn in ipairs(buttons) do
        btn:draw()
    end
end

function LevelSelect:mousepressed(x, y, button)
    for _, btn in ipairs(buttons) do
        btn:mousepressed(x, y, button)
    end
end

return LevelSelect
