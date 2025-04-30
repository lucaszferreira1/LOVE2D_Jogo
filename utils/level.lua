local Level = {}
Level.__index = Level

function Level:new(id, width, height, description)
    local instance = {
        id = id or 0,
        width = width or 0,
        height = height or 0,
        description = description or "",
        itemsIn = {},
        itemsOut = {},
        placeables = {}
    }
    setmetatable(instance, Level)
    return instance
end

function Level:addItemIn(item, position, quantity)
    table.insert(self.itemsIn, {item = item, position = position, quantity = quantity})
end

function Level:addItemOut(item, position, quantityRequired)
    table.insert(self.itemsOut, {item = item, position = position, quantityRequired = quantityRequired})
end

function Level:addPlaceable(item)
    table.insert(self.placeables, item)
end

function Level:getId()
    return self.id
end

function Level:getDescription()
    return self.description
end

function getWidth(self)
    return self.width
end

function getHeight(self)
    return self.height
end 

function Level:getItemsIn()
    return self.itemsIn
end

function Level:getItemsOut()
    return self.itemsOut
end

function Level:getPlaceables()
    return self.placeables
end

return Level