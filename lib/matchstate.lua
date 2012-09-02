MatchState = {}
MatchState.__index = MatchState
function MatchState:new(map)
	local o = {map = map
              ,teams = {}}
	setmetatable(o, self)
	return o
end

function MatchState:addTeam(teamName)
	self.teams[teamName] = {}
end

function MatchState:addTeamMember(teamName, characterId, i, j)
	local team = self.teams[teamName]
	local obj = {id = characterId, i = i, j = j}
	team[characterId] = obj
	return obj
end