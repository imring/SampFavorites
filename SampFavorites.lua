local bit = bit32 or require 'bit'

local function read_int(file)
	local numb, str = 0, file:read(4)
	for i = 0, 3 do
		numb = bit.bor(numb, bit.lshift(str:byte(i + 1), 8 * i))
	end
	return numb
end

local function write_int(file, numb)
	local str = ''
	for i = 0, 3 do
		local byte = bit.band(bit.rshift(numb, i * 8), 0xFF)
		str = str .. string.char(byte)
	end
	file:write(str)
end

local function open(self, path)
	local file = io.open(path, 'rb')

	self.isOpened = file ~= nil
	if not self.isOpened then return false end

	self.fileHeader.fileTag = file:read(4)

	if self.fileHeader.fileTag ~= 'SAMP' then
		file:close()
		return false
	end

	self.fileHeader.fileVersion = read_int(file)
	self.fileHeader.serversCount = read_int(file)

	local length = 0
	for i = 1, self.fileHeader.serversCount do
		-- ip address
		length = read_int(file)
		local address = file:read(length)
		
		-- port
		local port = read_int(file)
		
		-- hostname
		length = read_int(file)
		local hostname = file:read(length)
		
		-- password
		length = read_int(file)
		local password = file:read(length)
		
		-- rcon
		length = read_int(file)
		local rcon = file:read(length)
		self:addServer(address, port, hostname, password, rcon)
	end

	file:close()
	self.filePath = path
	return true
end

local function isOpen(self)
	return self.isOpened
end

local function save(self, path)
	local file = io.open(path, 'wb')

	self.isOpened = file ~= nil
	if not self.isOpened then return false end

	self.fileHeader.fileTag = 'SAMP'
	file:write(self.fileHeader.fileTag)
	write_int(file, self.fileHeader.fileVersion)
	self.fileHeader.serversCount = self:getServersCount()
	write_int(file, self.fileHeader.serversCount)

	for i = 1, self.fileHeader.serversCount do
		local fileServer = self:getServer(i)

		-- ip address
		write_int(file, #fileServer.address)
		file:write(fileServer.address)

		-- port
		write_int(file, fileServer.port)

		-- hostname
		write_int(file, #fileServer.hostname)
		file:write(fileServer.hostname)

		-- password
		write_int(file, #fileServer.password)
		file:write(fileServer.password)

		-- rcon
		write_int(file, #fileServer.rcon)
		file:write(fileServer.rcon)
	end
  
	file:close()
	self.filePath = path
	return true
end

local function getHeader(self)
	return self.fileHeader
end

local function setHeader(self, header)
	self.fileHeader = header
end

local function getServer(self, id)
	return self.fileServers[id]
end

local function setServer(self, id, server)
	self.fileServers[id] = server
end

local function addServer(self, address, port, hostname, password, rcon)
	self.fileServers[#self.fileServers + 1] = { address = address or '', port = port, hostname = hostname or '', password = password or '', rcon = rcon or '' }
end

local function getServersCount(self)
	return #self.fileServers
end

return function()
	return {
		filePath = '',
		isOpened = false,
		fileHeader = {},
		fileServers = {},

		open = open,
		isOpen = isOpen,
		save = save,

		getHeader = getHeader,
		setHeader = setHeader,

		getServer = getServer,
		setServer = setServer,
		addServer = addServer,
		getServersCount = getServersCount
	}
end