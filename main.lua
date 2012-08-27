require 'lib/spritesheet'
require 'lib/tilemap'

function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    lvl = loadfile("levels/test.lua")()
end

function love.update(dt)

end

function love.draw()
    love.graphics.clear()
    lvl:draw()
end