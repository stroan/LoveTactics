local level = {}

local tileSheet = SpriteSheet:new("images/tiles.png", 64, 64, 32, 48)
local tileHeights = {0, 32, 16}
local tileSprites = TileSprites:new(tileSheet, tileHeights)

local map = {{2, 3, 1, 1, 1}
		    ,{1, 1, 3, 1, 1}
		    ,{1, 1, 3, 1, 1}
		    ,{3, 1, 1, 1, 3}
		    ,{1, 1, 1, 1, 3}}

local objectSheet = SpriteSheet:new("images/big_object.png", 64, 128, 32, 112)
local bigObject = TileObject:new(objectSheet, 1, 96)

local tileMap = TileMap:new(tileSprites, map)
tileMap:addObject(bigObject, 1, 1)
tileMap:addObject(bigObject, 2, 1)
tileMap:addObject(bigObject, 1, 5)
tileMap:process()

return tileMap