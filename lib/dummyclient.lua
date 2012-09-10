local function catchAll()
	return function() end
end

local DummyClientParent = {}
DummyClientParent.__index = catchAll

DummyClient = {}
DummyClient.__index = DummyClient
setmetatable(DummyClient, DummyClientParent)

function DummyClient:new(server)
	local o = { id = "DUMMY"
	          , server = server
	          , timer = false
	          , team = {} }
	setmetatable(o, self)

	server:connectClient(o)

	return o
end

function DummyClient:setTeamId(id)
	self.id = id
end

function DummyClient:prepMatch()
	local team = { {}, {} }
    self.server:setTeam(self.id, team)
end

function DummyClient:update(dt)
	if self.timer ~= false then
		self.timer = self.timer + dt
		if self.timer > 2 then
			self.server:endTurn(self.id)
			self.timer = false
		end
	end
end

function DummyClient:setActiveTeamMember(team, character)
	if team == self.id then
		self.timer = 0
	end
end