local collides =
  Concord.component(
  function(e, vertices, offset)
    assert(type, "missing type for collides component")
    e.offset = offset or Vector(0, 0)
    e.hitbox = nil
  end
)

function collides:set_hitbox(hitbox)
  assert(hitbox)
  self.hitbox = hitbox
end

return collides
