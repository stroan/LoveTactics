require 'lib/resourceloader'

Client = {}
Client.__index = Client
function Client:new(server)
	o = {server = server}
	setmetatable(o, self)

	server:connectClient(o)

	return o
end

function Client:setLevel(levelName)
	self.levelName = levelName
	self.level = loadfile(levelName)()
	self.level:process(ResourceLoader:new(true))
end

function Client:update(dt)
	self.level:mouseOver(love.mouse.getX(), love.mouse.getY())
end

function Client:draw()
	love.graphics.clear()
	self.level:draw()
end