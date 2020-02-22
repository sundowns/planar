-- e is the Entity being assembled.
-- cuteness and legs are variables passed in
return Concord.assemblage(
  function(e, origin)
    local units = 10
    vertex_offsets = {
      Vector(-units, -units),
      Vector(0, units / math.sqrt(3)),
      Vector(units, -units)
    }
    local PLAYER_ACCELERATION = 360
    local bindings = {
      ["left"] = "left",
      ["right"] = "right",
      ["up"] = "up",
      ["down"] = "down",
      ["a"] = "left",
      ["d"] = "right",
      ["w"] = "up",
      ["s"] = "down"
    }

    e:give(_components.transform, origin, Vector(0, 0)):give(_components.polygon, vertex_offsets):give(
      _components.phase,
      true
    ):give(_components.flight, PLAYER_ACCELERATION):give(_components.control, bindings):give(_components.collides)
  end
)
