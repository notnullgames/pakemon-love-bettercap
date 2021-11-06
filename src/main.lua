-- setup some globals
conf = require "conf"
require "lib.REST-love.module-loader"
requireFromLib("lib/REST-love", "REST")
StateIntro = require("states.intro")

-- return boolean from env-var, or default value (false)
function boolenv(name, default)
  local e = string.lower(os.getenv(name) or default  or "")
  return e == "yes" or e == "1" or e == "true" or e == "y" or e == "t"
end

-- return string from env-var, or default value (empty string)
function strenv(name, default)
  return os.getenv(name) or default or ""
end

-- set dev in conf.lua to true to live-reload
if boolenv("PAKEMON_DEV") then
  lume = requireFromLib("lib/lume", "lume")
  lurker = requireFromLib("lib/lurker", "lurker")
end

current_state = StateIntro

function setstate(state)
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

function love.update(dt)
  if lurker then
    lurker.update()
  end
  REST.retrieve(dt)
  if current_state and current_state.update then
    current_state:update(dt)
  end
end

function love.draw()
  if current_state and current_state.draw then
    current_state:draw()
  end
end

function input_pressed(button)
  if current_state and current_state.pressed then
    current_state:pressed(button)
  end
end

function input_released(button)
  if current_state and current_state.released then
    current_state:released(button)
  end
end