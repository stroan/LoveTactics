local map = {{2, 3, 1, 1, 1, 1}
		    ,{1, 1, 3, 1, 1, 1}
		    ,{1, 1, 3, 1, 1, 1}
		    ,{3, 1, 1, 1, 3, 1}
		    ,{1, 1, 1, 1, 3, 1}
		    ,{1, 1, 1, 1, 1, 1}}

local objects = {{'bigObject', 1, 1}
                ,{'bigObject', 2, 1}
                ,{'bigObject', 3, 1}
                ,{'bigObject', 2, 2}
                ,{'bigObject', 3, 2}
                ,{'bigObject', 1, 5}}

local spawnPoints = {{5,5}
                    ,{3,3}}

return { map = TileMap:new('tiles', map, objects)
       , spawnPoints = spawnPoints }