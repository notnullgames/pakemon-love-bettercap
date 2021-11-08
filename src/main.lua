local add_path = require "lib.lovehandles.add_path"

add_path("lib")
add_path("lib/lovehandles")
add_path("lib/loverest")
add_path("lib/bitser")
add_path("lib/luajit-request")
add_path("lib/hump")
add_path("lib/lume")
add_path("lib/lurker")

json = require "dkjson"
bettercap = require "bettercap"
cron = require "cron"
require "inputmap"

StateHostList = require "states.host_list"

-- simple debug function to dump JSON
function debug(data)
  print(json.encode(data, { indent = 2 }))
end

-- return boolean from env-var, or default value (false)
function boolenv(name, default)
  local e = string.lower(os.getenv(name) or default  or "")
  return e == "yes" or e == "1" or e == "true" or e == "y" or e == "t"
end

-- return string from env-var, or default value (empty string)
function strenv(name, default)
  return os.getenv(name) or default or ""
end

-- switch to a new gamestate
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

dev_mode = boolenv("PAKEMON_DEV")
bettercap.url = strenv("PAKEMON_URL", bettercap.url)
time = 0

function love.update(dt)
  time = time + dt
  if lurker then
    lurker.update()
  end
  if current_state and current_state.update then
    current_state:update(dt)
  end
end

function love.draw()
  if current_state and current_state.draw then
    current_state:draw()
  end
end

function love.load()
  set_state(StateHostList)
  if dev_mode then
    print("Pakemon running in dev-mode")
    lume = require("lume")
    lurker = require("lurker")
  end
end

function love.quit()
  if current_state and current_state.leave then
    current_state:leave()
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