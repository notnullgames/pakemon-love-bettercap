require "lib.globals"

function love.update(dt)
  time = time + dt
  pcall(function() REST.retrieve(dt) end)
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
    lume = requireFromLib("lib/lume", "lume")
    lurker = requireFromLib("lib/lurker", "lurker")
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