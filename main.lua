require 'lib/spritesheet'
require 'lib/tilemap'

function love.load()
    tileSheet = SpriteSheet:new("images/tiles.png", 64, 64)
    tileMap = TileMap:new(tileSheet)
    love.graphics.setBackgroundColor(0,0,0)
end

function love.update(dt)

end

function love.draw()
    love.graphics.clear()
    tileMap:draw()
end