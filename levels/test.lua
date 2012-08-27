local level = {}

local tileSheet = SpriteSheet:new("images/tiles.png", 64, 64, 32, 48)
local tileSprites = TileSprites:new(tileSheet, 0)
tileSprites:setTileHeight(2, 16)
tileSprites:setTileHeight(1, 32)

local map = {{0, 1, 2, 0, 0}
		    ,{0, 0, 0, 0, 0}
		    ,{0, 0, 2, 0, 0}
		    ,{0, 2, 2, 0, 0}
		    ,{0, 0, 0, 0, 0}}

return TileMap:new(tileSprites, map)