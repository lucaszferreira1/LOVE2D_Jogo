local StateManager = {
    current = nil
}

function StateManager:switch(newState)
    if self.current and self.current.exit then self.current:exit() end
    self.current = newState
    if self.current.enter then self.current:enter() end
end

function StateManager:switchToLevel(newState, levelId)
    if self.current and self.current.exit then self.current:exit() end
    self.current = newState
    if self.current.enter then self.current:enter(levelId) end
end

function StateManager:switchToElectrical(newState, levelId, leve_data, grid)
    if self.current and self.current.exit then self.current:exit() end
    self.current = newState
    if self.current.enter then self.current:enter(levelId, leve_data, grid) end
end

function StateManager:update(dt)
    if self.current and self.current.update then self.current:update(dt) end
end

function StateManager:draw()
    if self.current and self.current.draw then self.current:draw() end
end

function StateManager:keypressed(key)
    if self.current and self.current.keypressed then self.current:keypressed(key) end
end

function StateManager:mousepressed(x, y, button)
    if self.current and self.current.mousepressed then self.current:mousepressed(x, y, button) end
end

return StateManager
