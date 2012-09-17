require 'lib/resourceloader'
require 'lib/matchstate'

local SCROLL_SPEED = 100

Client = {}
Client.__index = Client
function Client:new(server)
  local resourceLoader = ResourceLoader:new(true)
  local o = { server = server
            , cursor = Cursor:new()
            , selector = resourceLoader:getObject('selector')
            , resourceLoader = resourceLoader
            , pathTiles = {} }
  setmetatable(o, self)

  server:connectClient(o)

  return o
end

function Client:update(dt)
  local coords = self.level:mouseOver(love.mouse.getX(), love.mouse.getY())
  local activeMember = self.matchState:getCurrentMember()
  local canMove = self.matchState:canMove(coords)
  local isMyTurn = self.matchState.currentTeam == self.id

  -- Update cursor position
  self.level:removeDynObject(self.cursor)
  for _,v in ipairs(self.pathTiles) do
    self.level:removeDynObject(v)
  end
  self.pathTiles = {}
  if isMyTurn and canMove then
    local path = self.level:pathFind(activeMember.i, activeMember.j, coords.i, coords.j)
    for _,v in ipairs(path) do
      local tile = PathTile:new(self.selector)
      table.insert(self.pathTiles, tile)
      self.level:addDynObject(tile, v[1], v[2])
    end
    self.level:addDynObject(self.cursor, coords.i, coords.j)
  end

  -- Handle clicks
  if love.mouse.isDown('l') and isMyTurn and canMove then
    self.server:tryMove(self.matchState.currentTeam, self.matchState.currentMember, coords.i, coords.j)
  end

  -- Scroll map around with keyboard
  if love.keyboard.isDown('up') then
    self.level.offsetY = self.level.offsetY + (SCROLL_SPEED * dt)
  end
  if love.keyboard.isDown('down') then
    self.level.offsetY = self.level.offsetY - (SCROLL_SPEED * dt)
  end
  if love.keyboard.isDown('left') then
    self.level.offsetX = self.level.offsetX + (SCROLL_SPEED * dt)
  end
  if love.keyboard.isDown('right') then
    self.level.offsetX = self.level.offsetX - (SCROLL_SPEED * dt)
  end
end

function Client:draw()
  love.graphics.clear()
  self.level:draw()

  local y = 10
  for k,_ in pairs(self.matchState.teams) do
    local t = 'Team ' .. k
    if self.matchState.currentTeam == k then
      t = t .. ' < Character ' .. self.matchState.currentMember
    end
    love.graphics.print(t,10,y)
    y = y + 15
  end
end

function Client:prepMatch(levelName)
  self.levelName = levelName
  self.level = loadfile(levelName)().map
  self.level:process(self.resourceLoader)
  self.matchState = MatchState:new(self.level)

  local members = { {baseAP = 4}, {baseAP = 5} }
  self.server:setTeam(self.id, members)
end

function Client:setTeamId(id)
  self.id = id
end

function Client:addTeam(name)
  self.matchState:addTeam(name)
end

function Client:addTeamMember(team, name, details, i, j)
  local m = self.matchState:addTeamMember(team, name, details, i, j)
  colour = {0,255,0}
  if team == self.id then
    colour = {0,0,255}
  end
  m.drawable = PlayerDrawable:new(colour)
  self.level:addDynObject(m.drawable, i, j)
end

function Client:setActiveTeamMember(team, character)
  self.matchState:setActiveTeamMember(team, character)
  if team == self.id then
    local char = self.matchState.teams[team].members[character]
    self.level:addDynObject(self.selector, char.i, char.j)
  else
    self.level:removeDynObject(self.selector)
  end
end

function Client:moveCharacter(team, character, i, j)
  local c = self.matchState:move(team, character, i, j)
  self.level:moveDynObject(c.drawable, i, j)
  if self.matchState.currentTeam == self.id then
    self.level:moveDynObject(self.selector, i, j)
  end
end

Cursor = {}
Cursor.__index = Cursor
function Cursor:new()
  local o = {zIndex = 40}
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
function PlayerDrawable:new(colour)
  local o = {colour = colour
            ,zIndex = 20}
  setmetatable(o, self)
  return o
end

function PlayerDrawable:draw(x, y)
  love.graphics.setColor(self.colour[1],self.colour[2],self.colour[3],255)
  love.graphics.circle("fill", x, y, 10, 5)
  love.graphics.setColor(255,255,255,255)
end

PathTile = {}
PathTile.__index = PathTile
function PathTile:new(selector)
  local o = {zIndex = 1
            ,selector = selector}
  setmetatable(o, self)
  return o
end

function PathTile:draw(x, y)
  self.selector:draw(x,y)
end