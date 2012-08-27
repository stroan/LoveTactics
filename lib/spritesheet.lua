SpriteSheet = {}
SpriteSheet.__index = SpriteSheet
function SpriteSheet:new(filename, tileWidth, tileHeight)
	local img = love.graphics.newImage(filename)
	local imgWidth = img:getWidth()
	local imgHeight = img:getHeight()

	-- Generate quads for the tiles
	local cols = math.floor(imgWidth / tileWidth)
    local rows = math.floor(imgHeight / tileHeight)
    local quads = {}
    local i = 0

    for y=0,(rows-1) do
    	local ycoord = tileHeight * y
    	for x=0,(cols-1) do
    		local xcoord = tileWidth * x
    		quads[i] = love.graphics.newQuad(xcoord, ycoord, tileWidth, tileHeight, imgWidth, imgHeight)
    		i = i + 1
    	end
    end

	local o = { img = img, quads = quads, tileWidth = tileWidth, tileHeight = tileHeight }
	setmetatable(o, self)
	return o
end

function SpriteSheet:draw(index, x, y)
	love.graphics.drawq(self.img, self.quads[index], x, y)
end