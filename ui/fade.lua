local Fade = {
    alpha = 0,
    duration = 1,
    time = 0,
    active = false,
    phase = "none", -- "fade_out", "fade_in"
    onMidpoint = nil,
    onComplete = nil,
}

function Fade:start(duration, onMidpoint, onComplete)
    self.alpha = 0
    self.time = 0
    self.duration = duration or 1
    self.active = true
    self.phase = "fade_out"
    self.onMidpoint = onMidpoint
    self.onComplete = onComplete
end

function Fade:update(dt)
    if not self.active then return end

    self.time = self.time + dt
    local progress = math.min(self.time / self.duration, 1)

    if self.phase == "fade_out" then
        self.alpha = progress
        if progress >= 1 then
            self.time = 0
            self.phase = "fade_in"
            if self.onMidpoint then self.onMidpoint() end
        end
    elseif self.phase == "fade_in" then
        self.alpha = 1 - progress
        if progress >= 1 then
            self.phase = "none"
            self.active = false
            if self.onComplete then self.onComplete() end
        end
    end
end

function Fade:draw()
    if self.active or self.alpha > 0 then
        love.graphics.setColor(0, 0, 0, self.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Fade