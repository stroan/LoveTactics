
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
              , map = map
              , selectedI = 0
              , selectedJ = 0}
    setmetatable(o, self)
    return o
end

function TileMap:draw()
    local tiles = self.tiles.spriteSheet
    local tileWidth = tiles.tileWidth
    local halfTileHeight = tileWidth / 4
    local halfTileWidth = tileWidth / 2

    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)

    for i=0,(self.depth-1) do
        local thisX = halfTileWidth * -i
        local thisY = halfTileHeight * i
        for j=0,(self.width-1) do
            tiles:draw(self.map[i + 1][j + 1], thisX, thisY)
            thisX = thisX + halfTileWidth
            thisY = thisY + halfTileHeight
        end
    end

    selectedXY = self:ijToXY(self.selectedI, self.selectedJ)
    love.graphics.setColor(255,0,0,255)
    love.graphics.circle("fill", selectedXY.x, selectedXY.y, 10, 5)
    love.graphics.setColor(255,255,255,255)

    love.graphics.pop()
end

function TileMap:ijToXY(i, j)
    local tileWidth = self.tiles.spriteSheet.tileWidth
    return {x = (tileWidth / 2) * (j - i), y = (tileWidth / 4) * (j + i)}
end

function TileMap:mouseOver(x, y)
    local tiles = self.tiles.spriteSheet
    local heights = self.tiles.heights
    local tileWidth = tiles.tileWidth
    local halfTileHeight = tileWidth / 4
    local halfTileWidth = tileWidth / 2

    x = x - self.offsetX;
    y = y - self.offsetY;

    for i=0,(self.depth-1) do
        local thisX = halfTileWidth * -i
        local thisY = halfTileHeight * i
        for j=0,(self.width-1) do
            local h = heights[self.map[i + 1][j + 1]]
            local isoPart = (math.abs(thisX - x) / 2)

            local hit = (x > thisX - halfTileWidth) and (x < thisX + halfTileHeight) and (y > (thisY - halfTileHeight) - h) and (y < thisY + halfTileHeight)
                        and ((y < thisY) or y < (thisY + halfTileHeight) - isoPart)
                        and ((y > thisY - h) or y > ((thisY - h) - halfTileHeight) + isoPart)

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