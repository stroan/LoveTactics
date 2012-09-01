
-- Splits an image into an even grid of equally sized of 
-- tiles. The tiles are indexed by a single value, equal 
-- to (row * colCound + col)
--
-- +----------------+
-- | 1| 2| 3| 4| 5|x|   Shows how the indexes fit into
-- +----------------+   the base image. the 'x's mark
-- | 6| 7| 8| 9|10|x|   dead space that doesn't evenly
-- +----------------+   fit.
-- |       ...      |

SpriteSheet = {}
SpriteSheet.__index = SpriteSheet
function SpriteSheet:new(filename, tileWidth, tileHeight, centreX, centreY)
    local o = { filename = filename
              , tileWidth = tileWidth
              , tileHeight = tileHeight
              , centreX = centreX
              , centreY = centreY }
    setmetatable(o, self)
    return o
end

function SpriteSheet:load()
    local img = love.graphics.newImage(self.filename)
    local imgWidth = img:getWidth()
    local imgHeight = img:getHeight()

    -- Generate quads for the tiles
    local cols = math.floor(imgWidth / self.tileWidth)
    local rows = math.floor(imgHeight / self.tileHeight)
    local quads = {}
    local i = 1

    for y=0,(rows-1) do
        local ycoord = self.tileHeight * y
        for x=0,(cols-1) do
            local xcoord = self.tileWidth * x
            quads[i] = love.graphics.newQuad(xcoord, ycoord, self.tileWidth, self.tileHeight, imgWidth, imgHeight)
            i = i + 1
        end
    end

    self.img = img
    self.quads = quads
end

function SpriteSheet:draw(index, x, y)
    love.graphics.drawq(self.img, self.quads[index], x - self.centreX, y - self.centreY)
end