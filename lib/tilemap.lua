
-- Coordinate System:
-- (i,j)     (0,0)
--           ,--,
-- (2,0) ,--'    '--, (0,2)
--   ,--'            '--,
--
-- i axis = depth. j axis = width.

TileMap = {}
TileMap.__index = TileMap
function TileMap:new(tiles, map) 
    local o = { width = 5
              , depth = 5
              , tiles = tiles
              , offsetX = 300
              , offsetY = 100
              , map = map }
    setmetatable(o, self)
    return o
end

function TileMap:draw()
    local tiles = self.tiles.spriteSheet
    local tileWidth = tiles.tileWidth
    local tileHeight = tiles.tileHeight

    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)

    for i=0,(self.depth-1) do
        local thisX = (tileWidth / -2) * i
        local thisY = (tileWidth / 4) * i
        for j=0,(self.width-1) do
            tiles:draw(self.map[i + 1][j + 1], thisX, thisY)
            thisX = thisX + (tileWidth / 2)
            thisY = thisY + (tileWidth / 4)
        end
    end

    love.graphics.pop()
end

-- Wraps around a sprite sheet and contains information
-- about the nature of each tile. In particular it stores
-- the height of the tile in pixels.
TileSprites = {}
TileSprites.__index = TileSprites
function TileSprites:new(spriteSheet, defaultHeight) 
    local o = { defaults = {height = defaultHeight}
              , spriteSheet = spriteSheet
              , tileProperties = {} }
    setmetatable(o, self)
    return o
end

function TileSprites:setTileHeight(index, height)
    self:getTileProperties(index).height = height
end

function TileSprites:getTileProperties(index)
    local p = self.tileProperties[index]
    if not p then
        p = {}
        setmetatable(p, self.defaults)
        self.tileProperties[index] = p
    end
    return p
end