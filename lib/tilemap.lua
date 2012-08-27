
-- Coordinate System:
-- (i,j)     (0,0)
--           ,--,
-- (2,0) ,--'    '--, (0,2)
--   ,--'            '--,
--
-- i axis = depth. j axis = width.

TileMap = {}
TileMap.__index = TileMap
function TileMap:new(tiles) 
    local o = { width = 5
              , depth = 5
              , tiles = tiles
              , offsetX = 300
              , offsetY = 100
              , map = {{0, 1, 0, 0, 0}
                      ,{0, 0, 0, 0, 0}
                      ,{0, 0, 2, 0, 0}
                      ,{0, 2, 2, 0, 0}
                      ,{0, 0, 0, 0, 0}} }
    setmetatable(o, self)
    return o
end

function TileMap:draw()
    local tiles = self.tiles
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