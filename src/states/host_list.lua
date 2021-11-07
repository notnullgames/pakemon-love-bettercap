-- state that lists hosts on network

local StateHostList = {}

local hosts = {}
local host_timer
local current_selection = 1

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

-- called when this scene is entered
function StateHostList:enter()
  print("enabling recon")
  bettercap:run("net.probe on; net.recon on", debug)
  update_hosts()
end

-- called when this scene is left
function StateHostList:leave()
  print("disabling recon")
  bettercap:run("net.probe off; net.recon off", debug)
end

-- called often to update state 
function StateHostList:update(dt, time)
  -- it gets unset on lurker-reload, so this will recreate it
  if not host_timer then
    host_timer = cron.every(5, update_hosts)
  end
  host_timer:update(dt)
  local max = table.getn(hosts)
  if current_selection > max and max ~= 0 then
    current_selection = max
  end
end

-- called when a mapped button is pressed
function StateHostList:pressed(button)
  print(button)
  local max = table.getn(hosts)
  if button == "up" then
    current_selection = current_selection - 1
  end
  if button == "down" then
    current_selection = current_selection + 1
  end
  if current_selection > max then
    current_selection = 1
  end
  if current_selection < 1 then
    current_selection = max
  end
end

-- called when a mapped button is released
function StateHostList:released(button)
end

-- called often to draw current state
function StateHostList:draw()
  for i, host in pairs(hosts) do
    local offset = 10 + ((i-1) * 110)
    if i == current_selection then
      love.graphics.setColor(0, 0, 0.5, 1)
    else
      love.graphics.setColor(0, 0, 1, 1)
    end
    love.graphics.rectangle("fill", 10, offset, 620, 100, 10, 10)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 10, offset, 620, 100, 10, 10)
    love.graphics.printf(host["hostname"], 100, offset + 10, 520, "left")
    love.graphics.printf(host["ipv4"], 100, offset + 30, 520, "left")
    love.graphics.printf(host["mac"], 100, offset + 50, 520, "left")
    love.graphics.printf(host["ipv6"], 100, offset + 70, 520, "left")
  end
end

return StateHostList