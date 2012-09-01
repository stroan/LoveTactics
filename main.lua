require 'lib/server'
require 'lib/client'

local state = {}

function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    state.server = Server:new()
    state.client = Client:new(state.server)

    state.server:setLevel("levels/test.lua")
end

function love.update(dt)
    state.client:update(dt)
end

function love.draw()
    state.client:draw()
end