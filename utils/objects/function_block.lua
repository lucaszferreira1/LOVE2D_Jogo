local FunctionBlock = {}
FunctionBlock.__index = FunctionBlock

function FunctionBlock:new(name, description, eventInputs, eventOutputs, dataInputs, dataOutputs, algorithm)
    local fb = {
        name = name or "UnnamedFunctionBlock",
        x = 0,
        y = 0,
        eventInputs = eventInputs or {},
        eventOutputs = eventOutputs or {},
        dataInputs = dataInputs or {},
        dataOutputs = dataOutputs or {},
        algorithm = algorithm or nil,
    }
    setmetatable(fb, FunctionBlock)
    return fb
end

function FunctionBlock:addEventInput(eventName)
    self.eventInputs[eventName] = false
end

function FunctionBlock:addEventOutput(eventName)
    self.eventOutputs[eventName] = false
end

function FunctionBlock:addDataInput(dataName, initialValue)
    self.dataInputs[dataName] = initialValue or nil
end

function FunctionBlock:addDataOutput(dataName, initialValue)
    self.dataOutputs[dataName] = initialValue or nil
end

function FunctionBlock:execute(placeable)
    if self.algorithm and type(self.algorithm) == "function" then
        self.algorithm(self, placeable)
    else
        error("No valid algorithm defined for this FunctionBlock.")
    end
end

return FunctionBlock