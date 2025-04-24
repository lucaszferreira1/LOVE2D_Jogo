local ConveyorManager = {}
ConveyorManager.__index = ConveyorManager

function ConveyorManager:new()
    local instance = {
        conveyors = {}
    }
    setmetatable(instance, ConveyorManager)
    return instance
end

function ConveyorManager:addConveyor(conveyor)
    table.insert(self.conveyors, conveyor)
end

function ConveyorManager:moveItems()
    for i, conveyor in ipairs(self.conveyors) do
        if i < length(self.conveyors) then
            local nextConveyor = self.conveyors[i + 1]
            conveyor:moveItem(nextConveyor)
        end
    end
end

function ConveyorManager:update(dt)
    for _, conveyor in ipairs(self.conveyors) do
        conveyor:update(dt)
    end
end

function ConveyorManager:draw()
    for _, conveyor in ipairs(self.conveyors) do
        conveyor:draw()
    end
end

return ConveyorManager
