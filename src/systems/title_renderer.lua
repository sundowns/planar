-- Draws polygonal shapes to the screen
local title_renderer =
  Concord.system(
  {_components.transform, _components.polygon},
  {_components.control, _components.transform, _components.sprite, "PLAYER"}
)

function title_renderer:init()
  self.current_phase = "BLUE"
  self.colours = {
    ["RED"] = {220 / 255, 20 / 255, 60 / 255},
    ["BLUE"] = {30 / 255, 144 / 255, 1}
  }
  self.background_images = {
    ["BLUE"] = love.graphics.newImage("resources/backgrounds/blue.png"),
    ["RED"] = love.graphics.newImage("resources/backgrounds/red.png")
  }
  self.game_over_image = love.graphics.newImage("resources/misc/gameover.png")
  self.restart_prompt = love.graphics.newText(_fonts["RESTART"], "PRESS ENTER TO PLAY AGAIN")
  self.can_restart = false
  self.restart_timer = Timer.new()
  self.final_score_text = nil
  self.game_over = false
  -- Glowing line shader
  self.glow_effect = moonshine(moonshine.effects.glow).chain(moonshine.effects.godsray)
  self.glow_effect.glow.strength = 2
  self.glow_effect.godsray.exposure = 0.35
  self.glow_effect.godsray.weight = 0.4
end

function title_renderer:player_collided()
  --self:disable()
end

function title_renderer:update(dt)
  self.restart_timer:update(dt)
end

function title_renderer:display_final_score(final)
  self.game_over = true
  self.final_score_text = love.graphics.newText(_fonts["FINAL_SCORE"], "SCORE: " .. final)

  self.restart_timer:after(
    1.25,
    function()
      self.can_restart = true
    end
  )
end

function title_renderer:phase_update(new_phase)
  self.current_phase = new_phase
end

function title_renderer:draw_phased_polygon(e)
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

function title_renderer:draw_phased_sprite(e)
  local transform = e:get(_components.transform)
  local position = transform.position
  local sprite = e:get(_components.sprite)
  local phase = e:get(_components.phase)

  local shmangle = Vector(0, -1):angleTo(transform.velocity)

  if transform.velocity:len() == 0 then
    shmangle = transform.rotation
  else
    transform.rotation = shmangle
  end

  local image = sprite.images[phase.current]
  _util.l.resetColour()
  love.graphics.draw(image, position.x, position.y, -shmangle, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
end

function title_renderer:draw()
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

  love.graphics.setLineWidth(1)

  if self.shake_screen then
    love.graphics.pop()
  end
end

function title_renderer:draw_ui()
  -- final score display
  if self.game_over then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
      self.game_over_image,
      love.graphics.getWidth() / 2 - self.game_over_image:getWidth() / 2,
      love.graphics.getHeight() / 2 - self.game_over_image:getHeight() - self.final_score_text:getHeight()
    )
    love.graphics.setColor(_constants.SCORE.COLOUR)
    love.graphics.draw(
      self.final_score_text,
      love.graphics.getWidth() / 2 - self.final_score_text:getWidth() / 2,
      love.graphics.getHeight() / 2 - self.final_score_text:getHeight() / 2
    )
    if self.can_restart then
      love.graphics.draw(
        self.restart_prompt,
        love.graphics.getWidth() / 2 - self.restart_prompt:getWidth() / 2,
        love.graphics.getHeight() / 2 + self.final_score_text:getHeight() * 2
      )
    end
  end
end

-- this definitely doesnt belong here but...shut up!!
function title_renderer:keypressed(key)
  if self.can_restart and key == "return" then
    love.event.quit("restart")
  end
end

return title_renderer
