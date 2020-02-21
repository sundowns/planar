-- e is the Entity being assembled.
-- cuteness and legs are variables passed in
return Concord.assemblage(
  function(e, origin, phases)
    local triangle_vertex_offsets = {
      Vector(-10, -10),
      Vector(0, 10),
      Vector(10, -10)
    }
    local PLAYER_ACCELERATION = 320
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

    e:give(_components.transform, origin, Vector(0, 0)):give(_components.polygon, triangle_vertex_offsets):give(
      _components.phase,
      true
    ):give(_components.flight, PLAYER_ACCELERATION):give(_components.control, bindings)
  end
)
