local StateManager = require("utils.state_manager")

local Options = {}

local soundEnabled = true

function Options:enter()
    -- Nothing fancy for now
end

function Options:draw()
    love.graphics.printf("Options", 0, 100, love.graphics.getWidth(), "center")

    local soundText = soundEnabled and "Sound: ON" or "Sound: OFF"
    love.graphics.printf(soundText, 0, 180, love.graphics.getWidth(), "center")
    love.graphics.printf("[S] Toggle Sound", 0, 220, love.graphics.getWidth(), "center")
    love.graphics.printf("[B] Back to Menu", 0, 300, love.graphics.getWidth(), "center")
end

function Options:keypressed(key)
    if key == "s" then
        soundEnabled = not soundEnabled
    elseif key == "b" then
        local Menu = require("states.menu")
        StateManager:switch(Menu)
    end
end

return Options
