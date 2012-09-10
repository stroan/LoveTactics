require 'lib/resourceloader'
require 'lib/matchstate'

Server = {}
Server.__index = Server
function Server:new()
	o = {clients = {}}
	setmetatable(o, self)
	return o
end

function Server:prepMatch(levelName)
	self.levelName = levelName
	local levelFile = loadfile(levelName)()
	self.level = levelFile.map
	self.spawnPoints = levelFile.spawnPoints

	self.level:process(ResourceLoader:new(false))

	self.pendingTeams = 0

	 -- Inform all clients of the teams and the players
	for k1,c1 in pairs(self.clients) do
		c1:prepMatch(levelName)
		self.pendingTeams = self.pendingTeams + 1
	end

	-- Request teams from clients
	for k1,c1 in pairs(self.clients) do
		c1:requestTeam()
	end
end

function Server:startMatch()
	self.matchState = MatchState:new(self.level)

	local spawnPoints = self.spawnPoints
	local spawnIndex = 1

	-- Initialize the matchState
	for k,c in pairs(self.clients) do
		self.matchState:addTeam(k)
		local teamSpawnPoints = spawnPoints[spawnIndex]
		local teamSpawnIndex = 1

		for tk,tv in pairs(c.team) do
			self.matchState:addTeamMember(k, tk, teamSpawnPoints[teamSpawnIndex][1],
				                                 teamSpawnPoints[teamSpawnIndex][2])
			if teamSpawnIndex == 1 and spawnIndex == 1 then
				self.matchState:setActiveTeamMember(k, tk)
			end

			teamSpawnIndex = teamSpawnIndex + 1
		end

		spawnIndex = spawnIndex + 1
	end

    -- Inform all clients of the teams and the players
	for k1,c1 in pairs(self.clients) do
		for k2,c2 in pairs(self.clients) do
			c1:addTeam(k2)
			for charName,char in pairs(self.matchState.teams[k2].members) do
				c1:addTeamMember(k2, charName, char.i, char.j)
			end
		end
		c1:setActiveTeamMember(self.matchState.currentTeam, self.matchState.currentMember)
	end
end

function Server:connectClient(client)
	self.clients[client.id] = client
end

function Server:setTeam(clientName, team)
	self.clients[clientName].team = team
	self.pendingTeams = self.pendingTeams - 1
	
	if self.pendingTeams == 0 then
		self:startMatch()
	end
end

function Server:tryMove(team, character, i, j)
	local c = self.matchState.teams[team].members[character]
	c.i = i
	c.j = j

	for k,c in pairs(self.clients) do
		c:moveCharacter(team, character, i, j)
	end

	self:endTurn(self.matchState.currentTeam)
end

function Server:endTurn(team)
	self.matchState:moveNextTeamMember()

	for k,c in pairs(self.clients) do
		c:setActiveTeamMember(self.matchState.currentTeam, self.matchState.currentMember)
	end
end