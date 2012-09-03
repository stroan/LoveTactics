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

function MatchState:getCurrentMember()
	return self.teams[self.currentTeam][self.currentMember]
end

function MatchState:canMove(coords)
	if not coords then
		return false
	end

	for _,v in pairs(self.teams) do
		for _,v2 in pairs(v) do
			if v2.i == coords.i and v2.j == coords.j then
				return false
			end
		end
	end

	return true
end

function MatchState:getNextTeam()
	local o = {}
	for k,_ in pairs(self.teams) do
		table.insert(o, k)
	end
	table.sort(o)

    local nextI = 0
	for i,v in ipairs(o) do
		if v == self.currentTeam then
			nextI = i
			break
		end
	end

	return o[math.mod(nextI, table.getn(o)) + 1]
end