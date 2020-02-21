-- Draws polygonal shapes to the screen
local renderer = Concord.system({_components.transform, _components.polygon})

function renderer:init()
  self.phase = nil
end

function renderer:phase_change(new_phase)
  self.phase = new_phase
end

function renderer:draw()
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    local transform = e:get(_components.transform)
    local position = transform.position
    local polygon = e:get(_components.polygon)

    -- TODO: check current world phase (probably emit & store it) and decide the colour / drawing style (line vs fill)

    love.graphics.polygon("line", polygon:calculate_world_vertices(position))
  end
end
return renderer
