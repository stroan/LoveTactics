require 'lib/resourceloader'

Server = {}
Server.__index = Server
function Server:new()
	o = {clients = {}}
	setmetatable(o, self)
	return o
end

function Server:setLevel(levelName)
	self.levelName = levelName
	self.level = loadfile(levelName)()
	self.level:process(ResourceLoader:new(false))

	for _,c in ipairs(self.clients) do
		c:setLevel(levelName)
	end
end

function Server:connectClient(client)
	table.insert(self.clients, client)
end