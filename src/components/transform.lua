local transform =
  Concord.component(
  function(e, position, velocity, rotation)
    assert(position and position.x and position.y, "Transform component received a non-vector position on creation")
    assert(velocity and velocity.x and velocity.y, "Transform component received a non-vector velocity on creation")
    e.position = position
    e.velocity = velocity
    e.rotation = rotation or 0
  end
)

function transform:set_position(position)
  assert(position.x and position.y, "Transform component received a non-vector position when setting position")
  self.position = position
end

function transform:translate(dx, dy)
  self.position = Vector(self.position.x + dx, self.position.y + dy)
end

function transform:set_velocity(velocity)
  assert(velocity.x and velocity.y, "Transform component received a non-vector velocity when setting velocity")
  self.velocity = velocity
end

function transform:accelerate(dx, dy)
  self.velocity = Vector(self.velocity.x + dx, self.velocity.y + dy)
end

function transform:rotate(dr)
  self.rotation = self.rotation + dr
end

function transform:apply_friction(friction, dt)
  if self.velocity:len() > 0 then
    self.velocity = self.velocity - (self.velocity:normalized() * self.velocity:len() * friction) * dt
    -- big brain hack
    if self.velocity:len() < 5 and not love.keyboard.isDown("w", "a", "s", "d", "up", "left", "right", "down") then
      self.velocity = Vector(0, 0)
    end
  end
end

function transform:limit_speed(max_speed)
  local magnitude = self.velocity:len()
  local direction = self.velocity:normalized()
  if magnitude > max_speed then
    self.velocity = direction * max_speed
  end
end

return transform
