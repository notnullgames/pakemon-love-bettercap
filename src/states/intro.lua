local StateIntro = {}

-- called when this scene is entered
function StateIntro:enter()
  print(love.filesystem.getAppdataDirectory())
end

-- called when this scene is left
function StateIntro:leave()
end

-- called often to update state 
function StateIntro:update(dt)
end

-- called when a mapped button is pressed
function StateIntro:pressed(button)
end

-- called when a mapped button is released
function StateIntro:released(button)
end

-- called often to draw current state
function StateIntro:draw()
  love.graphics.printf( "It works!", 0, 230, 640, "center")
end

return StateIntro