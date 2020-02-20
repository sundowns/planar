local input = System({_components.controlled})

function input:init()
  self.timer = Timer.new()
  self.polling_rate = 0.01
  self.timer:every(
    self.polling_rate,
    function()
      self:poll_keys()
    end
  )
end

function input:poll_keys()
  for i = 1, self.pool.size do
    local controlled = self.pool:get(i):get(_components.controlled)
    for action, is_held in pairs(controlled.is_held) do
      if is_held then
        self:getInstance():emit("action_held", action, self.pool:get(i))
      end
    end
  end
end

function input:keypressed(key)
  for i = 1, self.pool.size do
    local controlled = self.pool:get(i):get(_components.controlled)
    local binds = controlled.binds
    if binds[key] and not controlled.is_held[key] then
      controlled.is_held[binds[key]] = true
      self:getInstance():emit("action_pressed", binds[key], self.pool:get(i))
    end
  end
end

function input:mousepressed(_, _, button)
  -- We dont care about x, y we just want to track the event (just poll the mouse position if needed)
  self:keypressed("mouse" .. button)
end

function input:mousereleased(_, _, button)
  -- We dont care about x, y we just want to track the event (just poll the mouse position if needed)
  self:keyreleased("mouse" .. button)
end

function input:keyreleased(key)
  for i = 1, self.pool.size do
    local controlled = self.pool:get(i):get(_components.controlled)
    local binds = controlled.binds
    if binds[key] and controlled.is_held[binds[key]] then
      controlled.is_held[binds[key]] = false
      self:getInstance():emit("action_released", binds[key], self.pool:get(i))
    end
  end
end

function input:update(dt)
  self.timer:update(dt)
end

return input
