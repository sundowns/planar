-- e is the Entity being assembled.
-- cuteness and legs are variables passed in
return Concord.assemblage(
  function(e, origin, phases)
    local triangle_vertex_offsets = {
      Vector(-10, -10),
      Vector(0, 10),
      Vector(10, -10)
    }

    e:give(_components.transform, origin, Vector(50, 0)):give(_components.polygon, triangle_vertex_offsets):give(
      _components.phase,
      phases
    )
  end
)
