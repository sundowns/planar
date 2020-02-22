local motion = Concord.system({_components.transform})
function motion:update(dt)
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    local transform = e:get(_components.transform)
    transform.position = transform.position + transform.velocity * dt
    if e:has(_components.control) then
      self:enforce_boundaries(transform)
    end
  end
end

function motion:enforce_boundaries(transform)
  -- horizontal
  local x_min = love.graphics.getWidth() / _constants.PLAYER.SIZE
  local x_max = love.graphics.getWidth() - x_min
  if transform.position.x > x_max then
    transform.position.x = x_max
    transform.velocity.x = 0
  elseif transform.position.x < x_min then
    transform.position.x = x_min
    transform.velocity.x = 0
  end

  -- vertical
  local y_min = love.graphics.getHeight() / _constants.PLAYER.SIZE
  local y_max = love.graphics.getHeight() - y_min
  if transform.position.y > y_max then
    transform.position.y = y_max
    transform.velocity.y = 0
  elseif transform.position.y < y_min then
    transform.position.y = y_min
    transform.velocity.y = 0
  end
end

return motion
