-- Draws polygonal shapes to the screen
local renderer =
  Concord.system(
  {_components.transform, _components.polygon},
  {_components.control, _components.transform, _components.sprite, "PLAYER"}
)

function renderer:init()
  self.current_phase = nil
  self.colours = {
    ["RED"] = {220 / 255, 20 / 255, 60 / 255},
    ["BLUE"] = {30 / 255, 144 / 255, 1}
  }
  self.background_images = {
    ["BLUE"] = love.graphics.newImage("resources/backgrounds/blue.png"),
    ["RED"] = love.graphics.newImage("resources/backgrounds/red.png")
  }
  self.final_score_text = nil
  self.game_over = false
  self.game_over_text = love.graphics.newText(_fonts["GAME_OVER"], "GAME OVER")
  -- Screen shake shit
  self.shake_screen = false
  self.shake_duration = 0
  self.shake_count = 0
  self.shake_magnitude = 2
  -- Glowing line shader
  self.glow_effect = moonshine(moonshine.effects.glow).chain(moonshine.effects.godsray)
  self.glow_effect.glow.strength = 2
  self.glow_effect.godsray.exposure = 0.35
  self.glow_effect.godsray.weight = 0.4
end

function renderer:player_collided()
  --self:disable()
end

function renderer:shake_screen(duration, magnitude)
  if self.shake_screen then
    return
  end
  self.shake_screen = true
  self.shake_duration = duration
  self.shake_magnitude = magnitude
end

function renderer:update(dt)
  if self.shake_screen then
    if self.shake_duration > self.shake_count then
      self.shake_count = self.shake_count + dt
    else
      self.shake_screen = false
      self.shake_count = 0
      self.shake_duration = 0
    end
  end

  local player = self.PLAYER:get(1)
  local position = player:get(_components.transform).position
  self.glow_effect.godsray.light_position = {
    position.x / love.graphics.getWidth(),
    position.y / love.graphics.getHeight()
  }
end

function renderer:display_final_score(final)
  self.game_over = true
  self.final_score_text = love.graphics.newText(_fonts["FINAL_SCORE"], "SCORE: " .. final)
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

function renderer:draw_phased_sprite(e)
  local transform = e:get(_components.transform)
  local position = transform.position
  local sprite = e:get(_components.sprite)
  local phase = e:get(_components.phase)

  local image = sprite.images[phase.current]
  _util.l.resetColour()
  love.graphics.draw(image, position.x - image:getWidth() / 2, position.y - image:getHeight() / 2)
end

function renderer:draw()
  _util.l.resetColour()
  -- draw background
  love.graphics.draw(
    self.background_images[self.current_phase],
    0,
    0,
    0,
    love.graphics.getWidth() / self.background_images[self.current_phase]:getWidth(),
    love.graphics.getHeight() / self.background_images[self.current_phase]:getHeight()
  )

  if self.shake_screen then
    love.graphics.push()
    local dx = love.math.random(-self.shake_magnitude, self.shake_magnitude)
    local dy = love.math.random(-self.shake_magnitude, self.shake_magnitude)
    love.graphics.translate(dx / self.shake_count, dy / self.shake_count)
  end

  love.graphics.setLineWidth(2)

  local current_phase_drawables = {}
  local alternate_phase_drawables = {}
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    local phase = e:get(_components.phase)
    if phase and not e:has(_components.sprite) then
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

  self.glow_effect.draw(
    function()
      for i, poly in ipairs(alternate_phase_drawables) do
        self:draw_phased_polygon(poly)
      end
    end
  )

  for i, poly in ipairs(current_phase_drawables) do
    self:draw_phased_polygon(poly)
  end

  self:draw_phased_sprite(self.PLAYER:get(1))

  -- self.blur_effect.draw(
  --   function()
  --     for i, poly in ipairs(current_phase_drawables) do
  --       self:draw_phased_polygon(poly)
  --     end
  --   end
  -- )

  love.graphics.setLineWidth(1)

  if self.shake_screen then
    love.graphics.pop()
  end
end

function renderer:draw_ui()
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
