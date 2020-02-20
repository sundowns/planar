local transform =
  Component(
  function(e, position, velocity)
    assert(position and position.x and position.y, "Transform component received a non-vector position on creation")
    assert(velocity and velocity.x and velocity.y, "Transform component received a non-vector velocity on creation")
    e.position = position
    e.velocity = velocity
  end
)

function transform:setPosition(position)
  assert(position.x and position.y, "Transform component received a non-vector position when setting position")
  self.position = position
end

function transform:translate(dx, dy)
  self.position = Vector(self.position.x + dx, self.position.y + dy)
end

function transform:setVelocity(velocity)
  assert(velocity.x and velocity.y, "Transform component received a non-vector velocity when setting velocity")
  self.velocity = velocity
end

return transform
