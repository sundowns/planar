local _instances = nil -- should not have visbility of each other...
_DEBUG = false

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
  -- Globals
  Vector = require("libs.vector")
  _constants = require("src.constants")
  _util = require("libs.util")
  resources = require("libs.cargo").init("resources")
  ECS =
    require("libs.concord").init(
    {
      useEvents = false
    }
  )
  Component = require("libs.concord.component")
  Entity = require("libs.concord.entity")
  Instance = require("libs.concord.instance")
  System = require("libs.concord.system")
  Timer = require("libs.timer")

  _components = require("src.components")
  _entities = require("src.entities")
  _systems = require("src.systems")
  _instances = require("src.instances")
end

function love.update(dt)
  _instances.world:emit("update", dt)
end

welcome_text = love.graphics.newText(love.graphics.getFont(), "Time to make a game...")
function love.draw()
  -- Draw filler text
  love.graphics.draw(
    welcome_text,
    love.graphics.getWidth() / 2 - welcome_text:getWidth() / 2,
    love.graphics.getHeight() / 2 - welcome_text:getHeight() / 2
  )

  _instances.world:emit("draw")
end

function love.keypressed(key, _, _)
  if key == "r" then
    love.event.quit("restart")
  elseif key == "escape" then
    love.event.quit()
  elseif key == "f1" then
    _DEBUG = not _DEBUG
  end

  _instances.world:emit("keypressed", key)
end

function love.keyreleased(key)
  _instances.world:emit("keyreleased", key)
end

function love.mousepressed(x, y, button, _, _)
  _instances.world:emit("mousepressed", x, y, button)
end

function love.mousereleased(x, y, button, _, _)
  _instances.world:emit("mousereleased", x, y, button)
end

function love.resize(w, h)
  _instances.world:emit("resize", w, h)
end
