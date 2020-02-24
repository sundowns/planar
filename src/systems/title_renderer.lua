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
  self.title_image = love.graphics.newImage("resources/misc/title.png")
  self.start_prompt = love.graphics.newText(_fonts["RESTART"], "PRESS SPACE TO START")
  self.can_restart = false
  self.restart_timer = Timer.new()
  self.restart_timer:after(
    2,
    function()
      self.can_restart = true
    end
  )
end

function title_renderer:update(dt)
  self.restart_timer:update(dt)
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
  _util.l.resetColour()

  love.graphics.setLineWidth(1)
end

function title_renderer:draw_ui()
  -- title display
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    self.title_image,
    love.graphics.getWidth() / 2 - self.title_image:getWidth() / 2,
    love.graphics.getHeight() / 2 - self.title_image:getHeight() - self.start_prompt:getHeight()
  )
  if self.can_restart then
    love.graphics.draw(
      self.start_prompt,
      love.graphics.getWidth() / 2 - self.start_prompt:getWidth() / 2,
      love.graphics.getHeight() / 2 + self.title_image:getHeight() * 2
    )
  end
end

-- this definitely doesnt belong here but...shut up!!
function title_renderer:keypressed(key)
  if self.can_restart and key == "return" then
    love.event.quit("restart")
  end
end

return title_renderer
