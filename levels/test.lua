local level = {}

local tileSheet = SpriteSheet:new("images/tiles.png", 64, 64, 32, 48)
local tileHeights = {0, 32, 16}
local tileSprites = TileSprites:new(tileSheet, tileHeights)

local map = {{2, 3, 3, 1, 1}
		    ,{1, 1, 3, 1, 1}
		    ,{1, 1, 3, 3, 3}
		    ,{1, 1, 3, 1, 1}
		    ,{2, 3, 3, 1, 1}}

return TileMap:new(tileSprites, map)