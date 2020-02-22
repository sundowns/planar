-- Draws polygonal shapes to the screen
local renderer = Concord.system({_components.transform, _components.polygon})

function renderer:init()
  self.current_phase = nil
  self.colours = {
    ["RED"] = {1, 0, 0},
    ["BLUE"] = {0, 0, 1}
  }
end

function renderer:phase_update(new_phase)
  self.current_phase = new_phase
end

function renderer:draw_phased_polygon(e)
  local transform = e:get(_components.transform)
  local position = transform.position
  local polygon = e:get(_components.polygon)
  local phase = e:get(_components.phase)

  local draw_mode = "fill"

  if phase then
    if self.current_phase ~= phase.current then
      draw_mode = "line"
    end

    love.graphics.setColor(self.colours[phase.current])
  end

  love.graphics.polygon(draw_mode, polygon:calculate_world_vertices(position))
end

function renderer:draw()
  love.graphics.setLineWidth(2)

  local current_phase_drawables = {}
  local alternate_phase_drawables = {}
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    local phase = e:get(_components.phase)
    if phase then
      if phase.current == self.current_phase then
        table.insert(current_phase_drawables, e)
      else
        table.insert(alternate_phase_drawables, e)
      end
    else
      -- draw phase-less objects
    end

    _util.l.resetColour()
  end

  for i, poly in ipairs(alternate_phase_drawables) do
    self:draw_phased_polygon(poly)
  end

  for i, poly in ipairs(current_phase_drawables) do
    self:draw_phased_polygon(poly)
  end

  love.graphics.setLineWidth(1)
end

return renderer
