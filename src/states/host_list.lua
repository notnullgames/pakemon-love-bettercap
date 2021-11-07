-- state that lists hosts on network

local StateHostList = {}

local hosts = {}

-- updates current table of hosts
local function update_hosts()
  local function process_hosts(data)
    if data then
      hosts = data["hosts"]
    else
      print("error getting hosts")
    end
  end
  print("getting hosts")
  bettercap:lan(nil, process_hosts)
end
local host_timer = cron.every(10, update_hosts)

-- called when this scene is entered
function StateHostList:enter()
  print("enabling recon")
  bettercap:run("net.probe on; net.recon on;", debug)
  update_hosts()
end

-- called when this scene is left
function StateHostList:leave()
  print("disabling recon")
  bettercap:run("net.probe off; net.recon off;", debug)
end

-- called often to update state 
function StateHostList:update(dt, time)
  host_timer:update(dt)
end

-- called when a mapped button is pressed
function StateHostList:pressed(button)
end

-- called when a mapped button is released
function StateHostList:released(button)
end

-- called often to draw current state
function StateHostList:draw()
  love.graphics.printf(json.encode(hosts, { indent = 2 }), 0, 230, 640, "center")
end

return StateHostList