require 'lib/resourceloader'
require 'lib/matchstate'

Server = {}
Server.__index = Server
function Server:new()
  o = { clients = {}
      , connectedClients = 0 }
  setmetatable(o, self)
  return o
end

function Server:prepMatch(levelName)
  self.levelName = levelName
  local levelFile = loadfile(levelName)()
  self.level = levelFile.map
  self.spawnPoints = levelFile.spawnPoints

  self.level:process(ResourceLoader:new(false))

  self.requiredTeams = levelFile.requiredTeams
  self.readyTeams = 0

   -- Inform all clients of the teams and the players
  for k1,c1 in pairs(self.clients) do
    c1:prepMatch(levelName)
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
      self.matchState:addTeamMember(k, tk, tv, teamSpawnPoints[teamSpawnIndex][1],
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
        c1:addTeamMember(k2, charName, char.details, char.i, char.j)
      end
    end
    c1:setActiveTeamMember(self.matchState.currentTeam, self.matchState.currentMember)
  end
end

function Server:connectClient(client)
  self.connectedClients = self.connectedClients + 1
  self.clients[self.connectedClients] = client
  client:setTeamId(self.connectedClients)
end

function Server:setTeam(clientName, team)
  self.clients[clientName].team = team
  self.readyTeams = self.readyTeams + 1
  
  if self.readyTeams == self.requiredTeams then
    self:startMatch()
  end
end

function Server:tryMove(team, character, i, j, cost)
  local c = self.matchState:move(team, character, i, j, cost)

  for k,c in pairs(self.clients) do
    c:moveCharacter(team, character, i, j, cost)
  end

  if c.state.currentAP == 0 then
    self:endTurn(self.matchState.currentTeam)
  end
end

function Server:endTurn(team)
  self.matchState:moveNextTeamMember()

  for k,c in pairs(self.clients) do
    c:setActiveTeamMember(self.matchState.currentTeam, self.matchState.currentMember)
  end
end