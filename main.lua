require 'lib/spritesheet'
require 'lib/tilemap'
require 'lib/resourceloader'

function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    lvl = loadfile("levels/test.lua")()
    lvl:process(ResourceLoader:new(true))
end

function love.update(dt)
    lvl:mouseOver(love.mouse.getX(), love.mouse.getY())
end

function love.draw()
    love.graphics.clear()
    lvl:draw()
end