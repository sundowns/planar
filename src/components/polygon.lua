-- regular polygonal shapes
-- Vertices are offsets relative to the centre of the polygon (0,0)
local polygon =
  Concord.component(
  function(e, vertices)
    assert(vertices and #vertices >= 3, "polygon component received less than 3 vertices")

    e.vertices = vertices
  end
)

function polygon:calculate_world_vertices(origin)
  local world_vertices = {}
  for i, vertex in ipairs(self.vertices) do
    world_vertices[#world_vertices + 1] = origin.x + vertex.x
    world_vertices[#world_vertices + 1] = origin.y + vertex.y
  end
  return world_vertices
end

return polygon
