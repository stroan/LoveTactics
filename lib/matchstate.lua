MatchState = {}
MatchState.__index = MatchState
function MatchState:new(map)
	local o = {map = map
              ,teams = {}
              ,teamCount = 0}
	setmetatable(o, self)
	return o
end

function MatchState:addTeam(teamName)
	self.teams[teamName] = {members = {}
						   ,memberCount = 0}
	self.teamCount = self.teamCount + 1
end

function MatchState:addTeamMember(teamName, characterId, i, j)
	local team = self.teams[teamName]
	local obj = {id = characterId, i = i, j = j}
	team.members[characterId] = obj
	team.memberCount = team.memberCount + 1
	return obj
end

function MatchState:setActiveTeamMember(team, character)
	self.currentTeam = team
	self.currentMember = character
	self.teams[team].lastMember = character
end

function MatchState:getCurrentMember()
	return self.teams[self.currentTeam].members[self.currentMember]
end

function MatchState:canMove(coords)
	if not coords then
		return false
	end

	for _,v in pairs(self.teams) do
		for _,v2 in pairs(v.members) do
			if v2.i == coords.i and v2.j == coords.j then
				return false
			end
		end
	end

	return true
end

function MatchState:getNextTeam()
	return math.mod(self.currentTeam, self.teamCount) + 1
end

function MatchState:getNextMember(team)
	local t = self.teams[team]
	return math.mod(t.lastMember or 0, t.memberCount) + 1
end

function MatchState:moveNextTeamMember()
	local t = self:getNextTeam()
	local m = self:getNextMember(t)
	self:setActiveTeamMember(t, m)
end