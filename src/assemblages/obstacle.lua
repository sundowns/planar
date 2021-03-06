-- e is the Entity being assembled.
-- cuteness and legs are variables passed in

local VALID_SHAPES = {["TRIANGLE"] = true, ["SQUARE"] = true, ["PENTAGON"] = true}

function get_shape_vertices(shape, scale, rotation)
  local units = 10
  units = units * scale
  local vertices = {}
  if shape == "TRIANGLE" then
    -- https://math.stackexchange.com/a/1344707
    vertices = {
      Vector(0, math.sqrt(3) / 3 * units),
      Vector(-units / 2, -math.sqrt(3) / 6 * units),
      Vector(units / 2, -math.sqrt(3) / 6 * units)
    }
  elseif shape == "SQUARE" then
    vertices = {
      Vector(-units, -units),
      Vector(units, -units),
      Vector(units, units),
      Vector(-units, units)
    }
  elseif shape == "PENTAGON" then
    -- https://math.stackexchange.com/a/1990548
    vertices = {
      Vector(0, units),
      Vector(units * math.cos(math.rad(18)), units * math.sin(math.rad(18))),
      Vector(units * math.cos(math.rad(-54)), units * math.sin(math.rad(-54))),
      Vector(-(units * math.cos(math.rad(-54))), units * math.sin(math.rad(-54))),
      Vector(-(units * math.cos(math.rad(18))), units * math.sin(math.rad(18)))
    }
  end

  -- apply initial rotation
  for i, vertex in ipairs(vertices) do
    vertices[i] = Vector(_util.m.rotatePointAroundOrigin(vertex.x, vertex.y, rotation))
  end

  return vertices
end

return Concord.assemblage(
  function(e, origin, velocity, phase, shape, scale, rotation)
    assert(phase == "RED" or phase == "BLUE", "received invalid phase to obstacle assemblage")
    assert(VALID_SHAPES[shape], "received invalid shape to obstacle assemblage: " .. shape)
    local scale = scale or 1
    local velocity = velocity or Vector(0, 0)
    local vertex_offsets = get_shape_vertices(shape, scale, rotation or 0)
    e:give(_components.transform, origin, velocity, rotation):give(_components.polygon, vertex_offsets):give(
      _components.phase,
      false,
      phase
    ):give(_components.collides):give(_components.spin, love.math.random(-2, 2))
  end
)
