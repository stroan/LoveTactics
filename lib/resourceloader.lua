require 'lib/spritesheet'
require 'lib/tilemap'

local tileSheets = {
	tiles = {fileName = "images/tiles.png"
            ,tileWidth = 64
            ,tileHeight = 64
            ,tileCentreX = 32
            ,tileCentreY = 48
            ,heights = {0, 32, 16}}
}

local objects = {
	bigObject = {fileName = "images/big_object.png"
                ,objectWidth = 64
                ,objectHeight = 128
                ,centreX = 32
                ,centreY = 112
                ,height = 96}
}

ResourceLoader = {}
ResourceLoader.__index = ResourceLoader
function ResourceLoader:new(client)
	local o = {isClient = client}
	setmetatable(o, self)
	return o
end

function ResourceLoader:getSpriteSheet(fileName, tileWidth, tileHeight, tileCentreX, tileCentreY)
	local spriteSheet = SpriteSheet:new(fileName, tileWidth, tileHeight, tileCentreX, tileCentreY)
	if self.isClient then
		spriteSheet:load()
	end
	return spriteSheet
end

function ResourceLoader:getTileSheet(resourceName)
	local d = tileSheets[resourceName]
	local tileSheet = self:getSpriteSheet(d.fileName, d.tileWidth, d.tileHeight, d.tileCentreX, d.tileCentreY)
	return TileSprites:new(tileSheet, d.heights)
end

function ResourceLoader:getObject(objectName)
	local d = objects[objectName]
	local objectSheet = self:getSpriteSheet(d.fileName, d.objectWidth, d.objectHeight, d.centreX, d.centreY)
	return TileObject:new(objectSheet, 1, d.height)
end