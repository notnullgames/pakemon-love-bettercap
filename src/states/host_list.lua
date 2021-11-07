-- state that lists hosts on network

local StateHostList = {}

local getting_hosts = false
local hosts = {}

local function debug(data)
  print(json.encode(data, { indent = 2 }))
end

-- updates current table of hosts
function update_hosts()
  if not getting_hosts then
    getting_hosts = true
    local function process_hosts(data)
      getting_hosts = false
      if data then
        hosts = data["hosts"]
      else
        print("error getting hosts")
      end
    end
    bettercap:lan(nil, process_hosts)
  end
end

-- called when this scene is entered
function StateHostList:enter()
  print("enabling recon")
  bettercap:run("net.probe on; net.recon on;", debug)
end

-- called when this scene is left
function StateHostList:leave()
  print("disabling recon")
 bettercap:run("net.probe off; net.recon off;", debug)
end

-- called often to update state 
function StateHostList:update(dt, time)
  -- every 10 seconds, refresh hosts
  if (math.floor(time) % 10) == 0 then
    update_hosts()
  end
end

-- called when a mapped button is pressed
function StateHostList:pressed(button)
end

-- called when a mapped button is released
function StateHostList:released(button)
end

-- called often to draw current state
function StateHostList:draw()
  local s = " "
  if getting_hosts then
    s = "*"
  end
  love.graphics.printf(s .. json.encode(hosts, { indent = 2 }), 0, 230, 640, "center")
end

return StateHostList