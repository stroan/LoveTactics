require 'lib/resourceloader'
require 'lib/matchstate'

Client = {}
Client.__index = Client
function Client:new(server)
	o = { server = server
        , id = "LOCAL"
        , cursor = Cursor:new()
        , drawables = {}}
	setmetatable(o, self)

	server:connectClient(o)

	return o
end

function Client:update(dt)
	local coords = self.level:mouseOver(love.mouse.getX(), love.mouse.getY())
	if coords then
		self.level:moveDynObject(self.cursor, coords.i, coords.j)
	end
end

function Client:draw()
	love.graphics.clear()
	self.level:draw()
end

function Client:beginMatch(levelName)
	self.levelName = levelName
	self.level = loadfile(levelName)().map
	self.level:process(ResourceLoader:new(true))
	self.matchState = MatchState:new(self.level)
	self.level:addDynObject(self.cursor, 1, 1)
end

function Client:addTeam(name)
	self.matchState:addTeam(name)
end

function Client:addTeamMember(team, name, i, j)
	local m = self.matchState:addTeamMember(team, name, i, j)
	m.drawable = PlayerDrawable:new()
	self.level:addDynObject(m.drawable, i, j)
end

Cursor = {}
Cursor.__index = Cursor
function Cursor:new()
	local o = {}
	setmetatable(o, self)
	return o
end

function Cursor:draw(x, y)
    love.graphics.setColor(255,0,0,255)
    love.graphics.circle("fill", x, y - 20, 10, 5)
    love.graphics.setColor(255,255,255,255)
end

PlayerDrawable = {}
PlayerDrawable.__index = PlayerDrawable
function PlayerDrawable:new()
	local o = {}
	setmetatable(o, self)
	return o
end

function PlayerDrawable:draw(x, y)
	love.graphics.setColor(0,255,0,255)
    love.graphics.circle("fill", x, y, 10, 5)
    love.graphics.setColor(255,255,255,255)
end