# SampFavorites
Lua library for working with SA-MP favorites list (USERDATA.DAT).  
Translated from SampFavorites by ziggi (https://github.com/ziggi/SampFavorites).  

# Usage
The example of usage this library:
```lua
local SampFavorites = require 'SampFavorites'

local data = SampFavorites()
data:open('files/USERDATA.dat')
if not data:isOpen() then
    error('Error reading file')
end

local header = data:getHeader()

print(header.fileTag .. '\n' ..
      header.fileVersion .. '\n' ..
      header.serversCount)

for i = 1, header.serversCount do
    local server = data:getServer(i)
    print(server.address .. ' | ' ..
          server.port .. ' | ' ..
          server.hostname .. ' | ' ..
          server.password .. ' | ' ..
          server.rcon)
end

data:addServer('999.000.111.32', 4322, 'test host', 'pass22', 'rcon1')
data:save('files/test.dat')
```