require "lib.REST-love.module-loader"
requireFromLib("lib/REST-love", "REST")
StateHostList = require "states.host_list"
json = require "lib.dkjson"
bettercap = require "lib.bettercap"

REST.isDebug = false

-- return boolean from env-var, or default value (false)
function boolenv(name, default)
  local e = string.lower(os.getenv(name) or default  or "")
  return e == "yes" or e == "1" or e == "true" or e == "y" or e == "t"
end

-- return string from env-var, or default value (empty string)
function strenv(name, default)
  return os.getenv(name) or default or ""
end

bettercap.url = strenv("PAKEMON_URL", bettercap.url)

dev_mode = boolenv("PAKEMON_DEV")

if dev_mode then
  print("Pakemon running in dev-mode")
  lume = requireFromLib("lib/lume", "lume")
  lurker = requireFromLib("lib/lurker", "lurker")
end

function set_state(state)
  if current_state and current_state.leave then
    current_state:leave()
  end
  if state then
    current_state = state
    if state.enter then
      state:enter()
    end
  end
end
set_state(StateHostList)

local time = 0
function love.update(dt)
  time = time + dt
  if lurker then
    lurker.update()
  end
  if current_state and current_state.update then
    current_state:update(dt, time)
  end
end

function love.draw()
  if current_state and current_state.draw then
    current_state:draw()
  end
end

function input_pressed(button)
  if dev_mode then
    -- there is also "dev" and "scene", for once I setup scenes for other options
    if button == "reload" then
      print("reload scene")
      set_state(current_state)
    end
  end

  if current_state and current_state.pressed then
    current_state:pressed(button)
  end
end

function input_released(button)
  if current_state and current_state.released then
    current_state:released(button)
  end
end