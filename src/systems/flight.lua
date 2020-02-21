local flight = Concord.system({_components.transform, _components.control, _components.flight})

-- TODO: friction
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

    local acceleration = direction * flight.acceleration * dt
    local limit = _constants.PLAYER.MAX_SPEED
    if math.abs(transform.velocity.x) > limit then
      acceleration.x = 0
    end
    if math.abs(transform.velocity.y) > limit then
      acceleration.y = 0
    end
    transform:accelerate(acceleration.x, acceleration.y)
    transform:apply_friction(_constants.PLAYER.FRICTION)
    print(transform.velocity.x .. " / " .. transform.velocity.y)
  end
end

return flight
