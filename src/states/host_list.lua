-- state that lists hosts on network

local StateHostList = {}

local hosts = {}
local host_timer
local current_selection = 1

-- this is a plain array of mac's to track what I have seen
local host_macs = {}

local camera = Camera(320, 0)

-- updates current table of hosts
local function update_hosts()
  local function process_hosts(data)
    if data then
      for _,host in pairs(data["hosts"]) do
        if not hosts[ host["mac"] ] then
          hosts[ host["mac"] ] = host
          table.insert(host_macs, host["mac"])
        end
      end
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
function StateHostList:update(dt)
  -- it gets unset on lurker-reload, so this will recreate it
  if not host_timer then
    host_timer = cron.every(5, update_hosts)
  end
  host_timer:update(dt)
  if current_selection > #hosts and #hosts ~= 0 then
    current_selection = #hosts
  end
  local page = math.floor((current_selection-1) / 4)
  camera:lookAt(320, (page * 440) + 240)
end

-- called when a mapped button is pressed
function StateHostList:pressed(button)
  if button == "up" then
    current_selection = current_selection - 1
  end
  if button == "down" then
    current_selection = current_selection + 1
  end
  if current_selection > #hosts then
    current_selection = 1
  end
  if current_selection < 1 then
    current_selection = #hosts
  end
end

-- called when a mapped button is released
function StateHostList:released(button)
end

-- called often to draw current state
function StateHostList:draw()
  camera:attach()
  for i, mac in pairs(host_macs) do
    local host = hosts[mac]
    local offset = 10 + ((i-1) * 110)
    if i == current_selection then
      love.graphics.setColor(0, 0, 1, 1)
    else
      love.graphics.setColor(0, 0, 0.5, 1)
    end
    love.graphics.rectangle("fill", 10, offset, 620, 100, 10, 10)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 10, offset, 620, 100, 10, 10)
    love.graphics.printf(host["hostname"], 100, offset + 10, 520, "left")
    love.graphics.printf(host["ipv4"], 100, offset + 30, 520, "left")
    love.graphics.printf(host["mac"], 100, offset + 50, 520, "left")
  end
  camera:detach()
end

return StateHostList