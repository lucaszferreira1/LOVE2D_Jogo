local Grid = {}
Grid.__index = Grid

-- Constructor for the Grid class, initializes a grid with the specified width and height
function Grid:new(width, height, itemsIn, itemsOut)
    local instance = setmetatable({}, Grid)
    instance.width = width
    instance.height = height
    instance.itemsIn = itemsIn or {}
    instance.itemsOut = itemsOut or {}
    instance.cells = {}
    for x = 1, width do
        instance.cells[x] = table.create and table.create(height, nil) or {}
        for y = 1, height do
           instance.cells[x][y] = nil
        end
    end

    return instance
end

function Level:addItemIn(item, position, quantity)
    table.insert(self.itemsIn, {item = item, position = position, quantity = quantity})
end

function Level:addItemOut(item, position, quantityRequired)
    table.insert(self.itemsOut, {item = item, position = position, quantityRequired = quantityRequired})
end

function Grid:isItemIn(x, y)
    for _, item in ipairs(self.itemsIn) do
        if item.position.x == x and item.position.y == y then
            return true, item
        end
    end
    return false, nil
end

function Grid:isItemOut(x, y)
    for _, item in ipairs(self.itemsOut) do
        if item.position.x == x and item.position.y == y then
            return true, item
        end
    end
    return false, nil
end

function Grid:isValidCell(x, y)
    return x >= 1 and x <= self.width and y >= 1 and y <= self.height
end

function Grid:isItemIO(x, y)
    return self:isItemIn(x, y) or self:isItemOut(x, y)
end

function Grid:addPlaceable(x, y, placeable)
    if self:isValidCell(x, y) then
        if not self:isItemIO(x, y) then
            self.cells[x][y] = placeable
        end
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