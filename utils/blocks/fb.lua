-- fb.lua
-- A simplified Function Block class based on IEC61499

local FunctionBlock = {}
FunctionBlock.__index = FunctionBlock

-- Constructor for a Function Block
function FunctionBlock:new(name, description)
    local fb = {
        name = name or "UnnamedFB",
        description = description or "No description provided",
        inputVariables = {},  -- {name = {type = "type"}}
        outputVariables = {}, -- {name = {type = "type"}}
        inputEvents = {},     -- {eventName = true}
        outputEvents = {}     -- {eventName = true}
    }
    setmetatable(fb, FunctionBlock)
    return fb
end

-- Add an input variable
function FunctionBlock:addInputVariable(name, varType)
    self.inputVariables[name] = {type = varType}
end

-- Add an output variable
function FunctionBlock:addOutputVariable(name, varType)
    self.outputVariables[name] = {type = varType}
end

-- Add an input event
function FunctionBlock:addInputEvent(eventName)
    self.inputEvents[eventName] = true
end

-- Add an output event
function FunctionBlock:addOutputEvent(eventName)
    self.outputEvents[eventName] = true
end

-- Set or update the description
function FunctionBlock:setDescription(description)
    self.description = description
end

-- Example execution function (to be overridden)
function FunctionBlock:execute(event)
    -- Placeholder for execution logic
    print("Executing Function Block: " .. self.name .. " on event: " .. event)
end

return FunctionBlock