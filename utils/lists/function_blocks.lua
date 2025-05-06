FunctionBlock = require("utils.objects.function_block")

local function sawFunction(self, placeable)
    if self.eventInputs["INIT"] then
        print("Saw is initialized.")
        self.eventOutputs["INITO"] = true
    end
end

local function drillFunction(self, placeable)
    if self.eventInputs["INIT"] then
        print("Saw is initialized.")
        self.eventOutputs["INITO"] = true
    end
end

local function cutterFunction(self, placeable)
    if self.eventInputs["INIT"] then
        print("Saw is initialized.")
        self.eventOutputs["INITO"] = true
    end
end

local fbs = {
    ["Saw"] = FunctionBlock:new("Saw", {{name="INIT"}}, {{name="INITO"}}, {}, {}, sawFunction),
    ["Drill"] = FunctionBlock:new("Drill", {{name="INIT"}}, {{name="INITO"}}, {}, {}, drillFunction),
    ["Cutter"] = FunctionBlock:new("Cutter", {{name="INIT"}}, {{name="INITO"}}, {}, {}, cutterFunction)
}

function fbs.getFBs()
    return fbs
end

function fbs.getFBByName(name)
    return fbs[name]
end

return fbs