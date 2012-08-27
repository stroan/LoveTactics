
-- Splits an image into an even grid of equally sized of 
-- tiles. The tiles are indexed by a single value, equal 
-- to (row * colCound + col)
--
-- +----------------+
-- | 0| 1| 2| 3| 4|x|   Shows how the indexes fit into
-- +----------------+   the base image. the 'x's mark
-- | 5| 6| 7| 8| 9|x|   dead space that doesn't evenly
-- +----------------+   fit.
-- |       ...      |

SpriteSheet = {}
SpriteSheet.__index = SpriteSheet
function SpriteSheet:new(filename, tileWidth, tileHeight, centreX, centreY)
    local img = love.graphics.newImage(filename)
    local imgWidth = img:getWidth()
    local imgHeight = img:getHeight()

    -- Generate quads for the tiles
    local cols = math.floor(imgWidth / tileWidth)
    local rows = math.floor(imgHeight / tileHeight)
    local quads = {}
    local i = 1

    for y=0,(rows-1) do
        local ycoord = tileHeight * y
        for x=0,(cols-1) do
            local xcoord = tileWidth * x
            quads[i] = love.graphics.newQuad(xcoord, ycoord, tileWidth, tileHeight, imgWidth, imgHeight)
            i = i + 1
        end
    end

    local o = { img = img
              , quads = quads
              , tileWidth = tileWidth
              , tileHeight = tileHeight
              , centreX = centreX
              , centreY = centreY }
    setmetatable(o, self)
    return o
end

function SpriteSheet:draw(index, x, y)
    love.graphics.drawq(self.img, self.quads[index + 1], x - self.centreX, y - self.centreY)
end