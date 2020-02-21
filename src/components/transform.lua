local transform =
  Concord.component(
  function(e, position, velocity)
    assert(position and position.x and position.y, "Transform component received a non-vector position on creation")
    assert(velocity and velocity.x and velocity.y, "Transform component received a non-vector velocity on creation")
    e.position = position
    e.velocity = velocity
    e.rotation = 0
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

function transform:apply_friction(friction)
  --vertical
  if self.velocity.y > 0 then
    self.velocity.y = self.velocity.y - friction
  elseif self.velocity.y < 0 then
    self.velocity.y = self.velocity.y + friction
  end

  if math.abs(self.velocity.y) < 2.5 then
    self.velocity.y = 0
  end

  --horizontal
  if self.velocity.x > 0 then
    self.velocity.x = self.velocity.x - friction
  elseif self.velocity.x < 0 then
    self.velocity.x = self.velocity.x + friction
  end

  if math.abs(self.velocity.x) < 2.5 then
    self.velocity.x = 0
  end
end

return transform
