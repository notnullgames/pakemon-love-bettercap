-- this is an interface to bettercap
-- requires REST (REST-love) and json (dkjson) in globals

-- settings: override as needed
local bettercap = {}

bettercap.url = "http://pakemon:pakemon@localhost:8081"

-- parse JSON returned before handing to callback
local function wrapcb(cb)
  local handler = function(data)
    if (data) then
      cb(json.decode(data))
    else
      cb(nil)
    end
  end
  return handler
end

-- GET /api/session
-- Get a JSON of the state of the current session
function bettercap:session(cb)
  print(bettercap.url .. '/api/session')
  REST.get(bettercap.url .. '/api/session', nil, wrapcb(cb))
end

-- GET /api/session/lan or /api/session/lan/00:AA:BB:CC:DD:11
-- Get a JSON of the lan devices in the current session
function bettercap:lan(mac, cb)
  if mac then
    REST.get(bettercap.url .. '/api/session/lan/' .. mac, nil, wrapcb(cb))
  else
    REST.get(bettercap.url .. '/api/session/lan', nil, wrapcb(cb))
  end
end

-- GET /api/session/wifi or /api/session/wifi/00:AA:BB:CC:DD:22
-- Get a JSON of the wifi devices (clients and access points) in the current session
function bettercap:wifi(mac, cb)
  if mac then
    REST.get(bettercap.url .. '/api/session/wifi/' + mac, nil, wrapcb(cb))
  else
    REST.get(bettercap.url .. '/api/session/wifi', nil, wrapcb(cb))
  end
end

-- GET /api/session/ble or /api/session/ble/00:AA:BB:CC:DD:33
-- Get a JSON of the BLE devices in the current session
function bettercap:ble(mac, cb)
  if mac then
    REST.get(bettercap.url .. '/api/session/ble/' + mac, nil, wrapcb(cb))
  else
    REST.get(bettercap.url .. '/api/session/ble', nil, wrapcb(cb))
  end
end

-- GET /api/session/hid or /api/session/hid/32:26:9f:a4:08
-- Get a JSON of the HID devices in the current session
function bettercap:hid(mac, cb)
  if mac then
    REST.get(bettercap.url .. '/api/session/hid/' + mac, nil, wrapcb(cb))
  else
    REST.get(bettercap.url .. '/api/session/hid', nil, wrapcb(cb))
  end
end

-- GET /api/session/env
-- Get a JSON of the environment variables in the current session
function bettercap:env(cb)
  REST.get(bettercap.url .. '/api/session/env', nil, wrapcb(cb))
end

-- GET /api/session/gateway
-- Get a JSON of the interface gateway of the current session
function bettercap:gateway(cb)
  REST.get(bettercap.url .. '/api/session/gateway', nil, wrapcb(cb))
end

-- GET /api/session/interface
-- Get a JSON of the main interface (wifi/lan) of the current session
function bettercap:interface(cb)
  REST.get(bettercap.url .. '/api/session/interface', nil, wrapcb(cb))
end

-- GET /api/session/options
-- Get a JSON of the options set for the current session
function bettercap:options(cb)
  REST.get(bettercap.url .. '/api/session/options', nil, wrapcb(cb))
end

-- GET /api/session/packets
-- Get a JSON of the packet traffic for the current session
function bettercap:packets(cb)
  REST.get(bettercap.url .. '/api/session/packets', nil, wrapcb(cb))
end

-- GET /api/session/started-at
-- Get a JSON of the time the current session was started
function bettercap:startedAt(cb)
  REST.get(bettercap.url .. '/api/session/started-at', nil, wrapcb(cb))
end

-- POST /api/session
-- Post a command to the interactive session
function bettercap:run(command, cb)
  REST.post(bettercap.url .. '/api/session', nil, { cmd = command } , wrapcb(cb))
end

-- GET /api/events
-- Return a list of events ( the optional n GET parameter will limit the number ):
function bettercap:events(n, cb)
  REST.get(bettercap.url .. '/api/events', nil, wrapcb(cb))
end

-- DELETE /api/events
-- Will clear the events buffer.
function bettercap:clearEvents(n, cb)
  if n then
    REST.delete(bettercap.url .. '/api/events', nil, { n = n }, wrapcb(cb))
  else
    REST.delete(bettercap.url .. '/api/events', nil, nil, wrapcb(cb))
  end
end

return bettercap