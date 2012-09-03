
-- Coordinate System:
-- (i,j)     (1,1)
--           ,--,
-- (3,1) ,--'    '--, (1,3)
--   ,--'            '--,
--
-- i axis = depth. j axis = width.

TileMap = { offsetX = 400
          , offsetY = 200 }
TileMap.__index = TileMap
function TileMap:new(tilesName, map, objects) 
    local o = { tilesName = tilesName
              , map = map
              , objects = {}
              , dynObjects = {}
              , dynObjectMap = {} }
    setmetatable(o, self)

    for _,v in pairs(objects) do
        o:addObject(v[1], v[2], v[3])
    end

    return o
end

function TileMap:addObject(object, i, j)
    local row = self.objects[i] or {}
    self.objects[i] = row
    row[j] = object
end

function TileMap:process(resourceLoader)
    -- Load the resource details
    self.tiles = resourceLoader:getTileSheet(self.tilesName)

    -- Get the size of the map
    self.depth = table.getn(self.map)
    self.width = table.getn(self.map[1])

    -- Precalculate the height map
    local heights = {}
    for i=1,self.depth do
        local row = {}
        heights[i] = row
        for j=1,self.width do
            row[j] = self.tiles.heights[self.map[i][j]]
            local o = (self.objects[i] or {})[j]
            if o then
                o = resourceLoader:getObject(o)
                self.objects[i][j] = o
                row[j] = row[j] + o.height
            end
        end
    end
    self.heights = heights
end

function TileMap:draw()
    local tiles = self.tiles.spriteSheet
    local tileWidth = tiles.tileWidth
    local halfTileHeight = tileWidth / 4
    local halfTileWidth = tileWidth / 2

    love.graphics.push()
    love.graphics.translate(math.floor(self.offsetX), math.floor(self.offsetY))

    for i=1,self.depth do
        local thisX = halfTileWidth * -(i - 1)
        local thisY = halfTileHeight * (i - 1)
        for j=1,self.width do
            tiles:draw(self.map[i][j], thisX, thisY)
            local o = (self.objects[i] or {})[j]
            if o then
                local height = self.tiles.heights[self.map[i][j]]
                o:draw(thisX, thisY - height)
            end

            local dynCell = self:getDynObjectCell(i, j)
            for _,v in pairs(dynCell) do
                v:draw(thisX, thisY - self.heights[i][j])
            end

            thisX = thisX + halfTileWidth
            thisY = thisY + halfTileHeight
        end
    end

    love.graphics.pop()
end

function TileMap:ijToXY(i, j)
    local tileWidth = self.tiles.spriteSheet.tileWidth
    i = i - 1
    j = j - 1
    return {x = (tileWidth / 2) * (j - i), y = (tileWidth / 4) * (j + i)}
end

-- Iterates over all tiles and checks to see if the mouse collides with it.
-- May have to optimize at some point, probably not though.
function TileMap:mouseOver(x, y)
    local tiles = self.tiles.spriteSheet
    local heights = self.heights
    local tileWidth = tiles.tileWidth
    local halfTileHeight = tileWidth / 4
    local halfTileWidth = tileWidth / 2

    x = x - self.offsetX;
    y = y - self.offsetY;

    local selectedI = nil
    local selectedJ = nil
    local match = false

    for i=1,self.depth do
        local thisX = halfTileWidth * -(i - 1)
        local thisY = halfTileHeight * (i - 1)
        for j=1,self.width do
            local h = heights[i][j]
            local isoPart = (math.abs(thisX - x) / 2)
            local topY = (thisY - halfTileHeight) - h
            local bottomY = thisY + halfTileHeight

            -- Check if the mouse is in the rect bounding box
            local hit = (x > thisX - halfTileWidth) and (x < thisX + halfTileHeight) and (y > topY) and (y < bottomY)
                        and ((y < thisY) or y < bottomY - isoPart) -- And not in the bottom excluded tris
                        and ((y > thisY - h) or y > topY + isoPart) -- And not in the top excluded tris

            if hit then
                match = true
                selectedI = i
                selectedJ = j
            end
            thisX = thisX + halfTileWidth
            thisY = thisY + halfTileHeight
        end
    end

    if match then
        return {i = selectedI, j = selectedJ}
    end
end

function TileMap:getDynObjectCell(i, j)
    local row = self.dynObjectMap[i] or {}
    self.dynObjectMap[i] = row
    local cell = row[j] or {}
    row[j] = cell
    return cell
end

function TileMap:addDynObject(object, i, j)
    local cell = self:getDynObjectCell(i, j)
    local index = 1
    for k,v in ipairs(cell) do
        index = k
        if v.zIndex > object.zIndex then
            break
        end
    end
    table.insert(cell, index, object)
    self.dynObjects[object] = {i = i, j = j}
end

function TileMap:moveDynObject(object, i, j)
    self:removeDynObject(object)
    self:addDynObject(object, i, j)
end

function TileMap:removeDynObject(object)
    local o = self.dynObjects[object]
    if o then
        local cell = self:getDynObjectCell(o.i, o.j)
        local index = 1
        for k,v in ipairs(cell) do
            index = k
            if v == object then
                break
            end
        end
        table.remove(cell, index)
        self.dynObjects[object] = nil
    end
end

-- Wraps around a sprite sheet and contains information
-- about the nature of each tile. In particular it stores
-- the height of the tile in pixels.
TileSprites = {}
TileSprites.__index = TileSprites
function TileSprites:new(spriteSheet, heights) 
    local o = { spriteSheet = spriteSheet
              , heights = heights }
    setmetatable(o, self)
    return o
end

TileObject = {}
TileObject.__index = TileObject
function TileObject:new(spriteSheet, index, height, zIndex)
    local o = { spriteSheet = spriteSheet
              , index = index
              , height = height
              , zIndex =  zIndex or 10}
    setmetatable(o, self)
    return o
end

function TileObject:draw(x, y)
    self.spriteSheet:draw(self.index, x, y)
end