local Grid = {}
Grid.__index = Grid

-- Constructor for the Grid class, initializes a grid with the specified width and height
function Grid:new(width, height)
    local instance = setmetatable({}, Grid)
    instance.width = width
    instance.height = height
    instance.cells = {}
    for x = 1, width do
        instance.cells[x] = table.create and table.create(height, nil) or {}
        for y = 1, height do
           instance.cells[x][y] = nil
        end
    end

    return instance
end

function Grid:addPlaceable(x, y, placeable)
    if self:isValidCell(x, y) then
        self.cells[x][y] = placeable
    else
        error("Invalid cell coordinates")
    end
end

function Grid:removePlaceable(x, y)
    if self:isValidCell(x, y) then
        self.cells[x][y] = nil
    else
        error("Invalid cell coordinates")
    end
end

function Grid:getPlaceable(x, y)
    if self:isValidCell(x, y) then
        return self.cells[x][y]
    else
        error("Invalid cell coordinates")
    end
end

return Grid