-- Draws polygonal shapes to the screen
local renderer = Concord.system({_components.transform, _components.polygon})

function renderer:init()
  self.current_phase = nil
  self.colours = {
    ["RED"] = {1, 0, 0},
    ["BLUE"] = {0, 0, 1}
  }
  self.final_score_text = nil
  self.game_over = false
  self.game_over_text = love.graphics.newText(love.graphics.getFont(), "GAME OVER")
end

function renderer:player_collided()
  --self:disable()
end

function renderer:display_final_score(final)
  self.game_over = true
  self.final_score_text = love.graphics.newText(love.graphics.getFont(), "Final score: " .. final)
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

  -- final score display
  if self.game_over then
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.draw(
      self.game_over_text,
      love.graphics.getWidth() / 2 - self.game_over_text:getWidth() / 2,
      love.graphics.getHeight() / 2 - self.game_over_text:getHeight() - self.final_score_text:getHeight()
    )
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.draw(
      self.final_score_text,
      love.graphics.getWidth() / 2 - self.final_score_text:getWidth() / 2,
      love.graphics.getHeight() / 2 - self.final_score_text:getHeight() / 2
    )
  end
end

return renderer
