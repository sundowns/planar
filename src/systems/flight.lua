local flight = Concord.system({_components.transform, _components.control, _components.flight, _components.trail})

function flight:update(dt)
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    self:update_entity_motion(e, dt)
    self:update_entity_trail(e, dt)
  end
end

function flight:update_entity_motion(e, dt)
  local transform = e:get(_components.transform)
  local control = e:get(_components.control)
  local flight = e:get(_components.flight)

  local direction = Vector(0, 0)
  if control.is_held["right"] and not control.is_held["left"] then
    direction.x = 1
  end
  if control.is_held["left"] and not control.is_held["right"] then
    direction.x = -1
  end
  if control.is_held["down"] and not control.is_held["up"] then
    direction.y = 1
  end
  if control.is_held["up"] and not control.is_held["down"] then
    direction.y = -1
  end

  transform:limit_speed(_constants.PLAYER.MAX_SPEED)
  local acceleration = direction * flight.acceleration * dt
  transform:accelerate(acceleration.x, acceleration.y)
  transform:apply_friction(_constants.PLAYER.FRICTION, dt)
end

function flight:update_entity_trail(e, dt)
  local trail = e:get(_components.trail)
  local transform = e:get(_components.transform)

  -- spawn behind the ship offset by half the width
  local offset_direction = -1 * (transform.velocity:clone():normalized())
  trail:update(dt, transform.position, offset_direction)

  local control = e:get(_components.control)
  if trail.system:isActive() then
    -- check if we should stop it
    if transform.velocity:len() < 10 then
      trail:stop()
    end
  else
    -- check if we should start it
    if transform.velocity:len() > 10 then
      trail:start()
    end
  end
end

function flight:draw()
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    e:get(_components.trail):draw(e:get(_components.transform).position)
  end
end

function flight:player_collided()
  self:disable()
end

return flight
