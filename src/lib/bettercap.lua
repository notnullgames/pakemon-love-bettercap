local bettercap = {}

bettercap.url = strenv("PAKEMON_URL", "http://localhost:8080")

-- need to work out how to use these
bettercap.user = strenv("PAKEMON_USER", "pakemon")
bettercap.password = strenv("PAKEMON_PASSWORD", "pakemon")


-- GET /api/session
-- Get a JSON of the state of the current session
function bettercap:session(cb)
  REST.get(bettercap.url + '/api/session', nil, cb)
end

-- GET /api/session/lan or /api/session/lan/00:AA:BB:CC:DD:11
-- Get a JSON of the lan devices in the current session
function bettercap:lan(mac, cb)
  if mac then
    REST.get(bettercap.url + '/api/session/lan/' + mac, nil, cb)
  else
    REST.get(bettercap.url + '/api/session/lan', nil, cb)
  end
end

-- GET /api/session/wifi or /api/session/wifi/00:AA:BB:CC:DD:22
-- Get a JSON of the wifi devices (clients and access points) in the current session
function bettercap:wifi(mac, cb)
  if mac then
    REST.get(bettercap.url + '/api/session/wifi/' + mac, nil, cb)
  else
    REST.get(bettercap.url + '/api/session/wifi', nil, cb)
  end
end

-- GET /api/session/ble or /api/session/ble/00:AA:BB:CC:DD:33
-- Get a JSON of the BLE devices in the current session
function bettercap:ble(mac, cb)
  if mac then
    REST.get(bettercap.url + '/api/session/ble/' + mac, nil, cb)
  else
    REST.get(bettercap.url + '/api/session/ble', nil, cb)
  end
end

-- GET /api/session/hid or /api/session/hid/32:26:9f:a4:08
-- Get a JSON of the HID devices in the current session
function bettercap:hid(mac, cb)
  if mac then
    REST.get(bettercap.url + '/api/session/hid/' + mac, nil, cb)
  else
    REST.get(bettercap.url + '/api/session/hid', nil, cb)
  end
end

-- GET /api/session/env
-- Get a JSON of the environment variables in the current session
function bettercap:env(cb)
  REST.get(bettercap.url + '/api/session/env', nil, cb)
end

-- GET /api/session/gateway
-- Get a JSON of the interface gateway of the current session
function bettercap:gateway(cb)
  REST.get(bettercap.url + '/api/session/gateway', nil, cb)
end

-- GET /api/session/interface
-- Get a JSON of the main interface (wifi/lan) of the current session
function bettercap:interface(cb)
  REST.get(bettercap.url + '/api/session/interface', nil, cb)
end

-- GET /api/session/options
-- Get a JSON of the options set for the current session
function bettercap:options(cb)
  REST.get(bettercap.url + '/api/session/options', nil, cb)
end

-- GET /api/session/packets
-- Get a JSON of the packet traffic for the current session
function bettercap:packets(cb)
  REST.get(bettercap.url + '/api/session/packets', nil, cb)
end

-- GET /api/session/started-at
-- Get a JSON of the time the current session was started
function bettercap:startedAt(cb)
  REST.get(bettercap.url + '/api/session/started-at', nil, cb)
end

-- POST /api/session
-- Post a command to the interactive session
function bettercap:run(command, cb)
  REST.post(bettercap.url + '/api/session', nil, { command = command } , cb)
end

-- GET /api/events
-- Return a list of events ( the optional n GET parameter will limit the number ):
function bettercap:events(n, cb)
  REST.get(bettercap.url + '/api/events', nil, cb)
end

-- DELETE /api/events
-- Will clear the events buffer.
function bettercap:clearEvents(n, cb)
  if n then
    REST.delete(bettercap.url + '/api/events', nil, { n = n }, cb)
  else
    REST.delete(bettercap.url + '/api/events', nil, nil, cb)
  end
end

-- TODO: add a bunch of runs here

return bettercap