-- Draws polygonal shapes to the screen
local title_renderer = Concord.system({_components.transform, _components.polygon})

function title_renderer:init()
  self.colours = {
    ["RED"] = {220 / 255, 20 / 255, 60 / 255},
    ["BLUE"] = {30 / 255, 144 / 255, 1}
  }
  self.background_image = love.graphics.newImage("resources/backgrounds/blue.png")
  self.controls_header = love.graphics.newImage("resources/misc/controls.png")

  self.controls_text = love.graphics.newText(_fonts["CONTROLS"], "[SPACE] - Phase Shift\n\n[WASD/Arrows] - Move")

  self.title_image = love.graphics.newImage("resources/misc/title.png")
  self.start_prompt = love.graphics.newText(_fonts["RESTART"], "PRESS SPACE TO START")
  self.can_start = false
  self.start_timer = Timer.new()
  self.start_timer:after(
    1.5,
    function()
      self.can_start = true
    end
  )
  self.blink_text = false
  self.start_timer:every(
    1.5,
    function()
      self.blink_text = not self.blink_text
    end
  )
end

function title_renderer:update(dt)
  self.start_timer:update(dt)
end

function title_renderer:draw()
  _util.l.resetColour()
  -- draw background
  love.graphics.draw(
    self.background_image,
    0,
    0,
    0,
    love.graphics.getWidth() / self.background_image:getWidth(),
    love.graphics.getHeight() / self.background_image:getHeight()
  )
  _util.l.resetColour()
end

function title_renderer:draw_ui()
  -- title display
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    self.title_image,
    love.graphics.getWidth() / 2 - self.title_image:getWidth() / 2,
    love.graphics.getHeight() / 2 - self.title_image:getHeight() - self.start_prompt:getHeight()
  )
  if self.can_start and self.blink_text then
    love.graphics.draw(
      self.start_prompt,
      love.graphics.getWidth() / 2 - self.start_prompt:getWidth() / 2,
      love.graphics.getHeight() / 2 + self.start_prompt:getHeight()
    )
  end

  love.graphics.draw(
    self.controls_header,
    love.graphics.getWidth() / 2 - self.controls_header:getWidth() / 2,
    love.graphics.getHeight() / 2 + self.title_image:getHeight() * 2
  )
  love.graphics.draw(
    self.controls_text,
    love.graphics.getWidth() / 2 - self.controls_text:getWidth() / 2,
    love.graphics.getHeight() / 2 + self.title_image:getHeight() * 2.75
  )
end

return title_renderer
