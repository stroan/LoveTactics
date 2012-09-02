local function catchAll()
	return function() end
end

DummyClient = {}
DummyClient.__index = catchAll
function DummyClient:new(server)
	local o = { id = "DUMMY"
	          , server = server}
	setmetatable(o, self)

	server:connectClient(o)

	return o
end