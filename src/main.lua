-- setup some globals
conf = require "conf"
require "lib.REST-love.module-loader"
requireFromLib("lib/REST-love", "REST")
StateIntro = require("states.intro")

-- set dev in conf.lua to true to live-reload
if conf.dev then
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