require 'lib/resourceloader'
require 'lib/matchstate'

Server = {}
Server.__index = Server
function Server:new()
	o = {clients = {}}
	setmetatable(o, self)
	return o
end

function Server:beginMatch(levelName)
	self.levelName = levelName
	local levelFile = loadfile(levelName)()
	self.level = levelFile.map
	self.level:process(ResourceLoader:new(false))

	local spawnPoints = levelFile.spawnPoints

	local spawnIndex = 1
	self.matchState = MatchState:new(self.level)

	-- Initialize the matchState
	for k,c in pairs(self.clients) do
		self.matchState:addTeam(k)
		self.matchState:addTeamMember(k, "character1", spawnPoints[spawnIndex][1], spawnPoints[spawnIndex][2])
		if spawnIndex == 1 then
			self.matchState.currentTeam = k
		end
		spawnIndex = spawnIndex + 1
	end

    -- Inform all clients of the teams and the players
	for k1,c1 in pairs(self.clients) do
		c1:beginMatch(levelName)
		for k2,c2 in pairs(self.clients) do
			c1:addTeam(k2)
			for charName,char in pairs(self.matchState.teams[k2]) do
				c1:addTeamMember(k2, charName, char.i, char.j)
			end
		end
		c1:setActiveTeamMember(self.matchState.currentTeam, "character1")
	end
end

function Server:connectClient(client)
	self.clients[client.id] = client
end