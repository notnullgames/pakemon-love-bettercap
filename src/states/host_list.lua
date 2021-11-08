-- state that lists hosts on network

local Camera = require("camera")
local StateHostList = {}

local hosts = {}
local host_timer
local host_handle
local current_selection = 1

-- this is a plain array of mac's to track what I have seen
local host_macs = {}

local camera = Camera(320, 0)

local faceImage = love.graphics.newImage("images/faces.png")
local faces = {}

for x = 0,8 do
  for y = 0,9 do
    table.insert(faces, love.graphics.newQuad((x*95) +x, (y*95)+y, 95, 95, faceImage:getDimensions()))
  end
end

-- called when this scene is entered
function StateHostList:enter()
  print("enabling recon")
  bettercap:run("net.probe on; net.recon on")
  host_handle = bettercap:lan()
  host_timer = cron.every(10, function() host_handle = bettercap:lan() end)
end

-- called when this scene is left
function StateHostList:leave()
  print("disabling recon")
  bettercap:run("net.probe off; net.recon off")
end

-- called often to update state 
function StateHostList:update(dt)
  -- stuff gets unset on lurker-reload, so this will recreate it
  if not host_timer then
    StateHostList:enter()
  end
  host_timer:update(dt)
  local data, error = host_handle()
  if data and not error and not data._processed then
    data._processed = true
    for _, host in pairs(data["hosts"]) do
      if not hosts[ host["mac"] ] then
        hosts[ host["mac"] ] = host
        hosts[ host["mac"] ]["image"] = math.random(1, #faces)
        table.insert(host_macs, host["mac"])
      end
    end
  end
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
  if current_selection > #host_macs then
    current_selection = 1
  end
  if current_selection < 1 then
    current_selection = #host_macs
  end
end

-- called often to draw current state
function StateHostList:draw()
  if #host_macs == 0 then
    love.graphics.setColor(0, 0, 0.5, 1)
    love.graphics.rectangle("fill", 100, 212, 420, 50, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 100, 212, 420, 50, 10, 10)
    local el = ""
    for i=0,(math.floor(time) % 4) do el = el .. "." end
    love.graphics.printf("Searching for hosts" .. el, 0, 230, 640, "center")
  end
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
    love.graphics.printf(host["hostname"], 120, offset + 10, 520, "left")
    love.graphics.printf(host["ipv4"], 120, offset + 30, 520, "left")
    love.graphics.printf(host["mac"], 120, offset + 50, 520, "left")
    love.graphics.draw(faceImage, faces[host["image"]], 17, offset + 3)
  end
  camera:detach()
end

return StateHostList