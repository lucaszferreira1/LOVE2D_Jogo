local StateManager = require("utils.state_manager")
local Fade = require("ui.fade")
local Menu = require("states.menu")

function love.load()
    love.window.setTitle("Factory Game")
    StateManager:switch(Menu)
end

function love.update(dt)
    StateManager:update(dt)
    Fade:update(dt)
end

function love.draw()
    StateManager:draw()
    Fade:draw()
end

function love.keypressed(key)
    StateManager:keypressed(key)
end

function love.mousepressed(x, y, button)
    if StateManager.mousepressed then
        StateManager:mousepressed(x, y, button)
    end
end
