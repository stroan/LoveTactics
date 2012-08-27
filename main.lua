require 'lib/spritesheet'

function love.load()
    tileSheet = SpriteSheet:new("images/tiles.png", 64, 64)
    love.graphics.setBackgroundColor(0,0,0)
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.clear()
    tileSheet:draw(1, 128, 48)
    tileSheet:draw(1, 32, 32)
    tileSheet:draw(2, 64, 48)
    tileSheet:draw(0, 96, 64)
end