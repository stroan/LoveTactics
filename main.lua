require 'lib/server'
require 'lib/client'
require 'lib/dummyclient'
require 'lib/inspect'

state = {}

function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    state.server = Server:new()
    state.client = Client:new(state.server)
    state.dummyClient = DummyClient:new(state.server)

    state.server:prepMatch("levels/test.lua")
end

function love.update(dt)
    state.client:update(dt)
    state.dummyClient:update(dt)
end

function love.draw()
    state.client:draw()
end