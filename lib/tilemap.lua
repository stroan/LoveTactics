
-- Coordinate System:
-- (i,j)     (1,1)
--           ,--,
-- (3,1) ,--'    '--, (1,3)
--   ,--'            '--,
--
-- i axis = depth. j axis = width.

TileMap = { selectedI = 1
          , selectedJ = 1 
          , offsetX = 400
          , offsetY = 200 }
TileMap.__index = TileMap
function TileMap:new(tiles, map) 
    local o = { tiles = tiles
              , map = map
              , objects = {} }
    setmetatable(o, self)
    return o
end

function TileMap:addObject(object, i, j)
    local row = self.objects[i] or {}
    self.objects[i] = row
    row[j] = object
end

function TileMap:process()
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
    love.graphics.translate(self.offsetX, self.offsetY)

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
            thisX = thisX + halfTileWidth
            thisY = thisY + halfTileHeight
        end
    end

    local selectedXY = self:ijToXY(self.selectedI, self.selectedJ)
    local h = self.heights[self.selectedI][self.selectedJ]
    love.graphics.setColor(255,0,0,255)
    love.graphics.circle("fill", selectedXY.x, selectedXY.y - h, 10, 5)
    love.graphics.setColor(255,255,255,255)

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
                self.selectedI = i
                self.selectedJ = j
            end
            thisX = thisX + halfTileWidth
            thisY = thisY + halfTileHeight
        end
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
function TileObject:new(spriteSheet, index, height)
    local o = { spriteSheet = spriteSheet
              , index = index
              , height = height }
    setmetatable(o, self)
    return o
end

function TileObject:draw(x, y)
    self.spriteSheet:draw(self.index, x, y)
end