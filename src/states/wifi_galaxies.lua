local StateWifiGalaxies = {}

local wifi = {}
local wifi_timer
local wifi_handle

-- called when this scene is entered
function StateWifiGalaxies:enter()
  print("enabling recon")
  bettercap:run("wifi.recon on")
  wifi_handle = bettercap:wifi()
  wifi_timer = cron.every(10, function() wifi_handle = bettercap:wifi() end)
end

-- called when this scene is left
function StateWifiGalaxies:leave()
  print("disabling recon")
  bettercap:run("wifi.recon off")
end

-- called often to update state 
function StateWifiGalaxies:update(dt)
  -- stuff gets unset on lurker-reload, so this will recreate it
  if not wifi_timer then
    StateWifiGalaxies:enter()
  end
  wifi_timer:update(dt)
  local data, error = wifi_handle()
  if data and not error and not data._processed then
    data._processed = true
    debug(data)
  end
end

-- called when a mapped button is pressed
function StateWifiGalaxies:pressed(button)
end

-- called when a mapped button is released
function StateWifiGalaxies:released(button)
end

-- called often to draw current state
function StateWifiGalaxies:draw()
end

return StateWifiGalaxies