local flight = Concord.system({_components.transform, _components.control, _components.flight})

function flight:update(dt)
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
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
end

function flight:player_collided()
  self:disable()
end

return flight
