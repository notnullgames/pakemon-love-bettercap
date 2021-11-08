-- this is an interface to bettercap

local rest = require "loverest"
local json = require "dkjson"

local bettercap = {}

-- settings: override as needed
bettercap.url = "http://pakemon:pakemon@localhost:8081"

-- Get a JSON of the lan devices in the current session
function bettercap:lan(mac)
  if mac then
    return rest:get(bettercap.url .. '/api/session/lan/' .. mac)
  else
    return rest:get(bettercap.url .. '/api/session/lan')
  end
end

-- Post a command to the interactive session: fire & forget
function bettercap:run(command)
  return rest:post(bettercap.url .. '/api/session', { cmd = command })
end

return bettercap