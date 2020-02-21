-- e is the Entity being assembled.
-- cuteness and legs are variables passed in

local VALID_SHAPES = {["RECTANGLE"] = true, ["TRIANGLE"] = true, ["SQUARE"] = true}

function get_shape_vertices(shape)
  if shape == "TRIANGLE" then
    return {
      Vector(-10, -10),
      Vector(0, 10),
      Vector(10, -10)
    }
  elseif shape == "SQUARE" then
    return {
      Vector(-10, -10),
      Vector(10, -10),
      Vector(10, 10),
      Vector(-10, 10)
    }
  end
end

return Concord.assemblage(
  function(e, origin, velocity, phase, shape)
    assert(phase == "RED" or phase == "BLUE", "received invalid phase to obstacle assemblage: " .. phase)
    assert(VALID_SHAPES[shape], "received invalid shape to obstacle assemblage: " .. shape)
    local velocity = velocity or Vector(0, 0)

    local vertex_offsets = get_shape_vertices(shape)
    e:give(_components.transform, origin, velocity):give(_components.polygon, vertex_offsets):give(
      _components.phase,
      false,
      phase
    )
  end
)
