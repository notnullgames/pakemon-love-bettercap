local StateTemplate = {}

-- called when this scene is entered
function StateTemplate:enter()
end

-- called when this scene is left
function StateTemplate:leave()
end

-- called often to update state 
function StateTemplate:update(dt, time)
end

-- called when a mapped button is pressed
function StateTemplate:pressed(button)
end

-- called when a mapped button is released
function StateTemplate:released(button)
end

-- called often to draw current state
function StateTemplate:draw()
end

return StateTemplate