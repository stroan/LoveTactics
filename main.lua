require 'lib/spritesheet'
require 'lib/tilemap'

function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    lvl = loadfile("levels/test.lua")()

    x = 0
    y = 0
end

function love.update(dt)
    x = love.mouse.getX()
    y = love.mouse.getY()
    lvl:mouseOver(x,y)
end

function love.draw()
    love.graphics.clear()
    lvl:draw()
    love.graphics.circle("fill", x, y, 5, 3)
end