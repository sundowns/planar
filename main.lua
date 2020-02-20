local _worlds = nil -- should not have visbility of each other...
_DEBUG = false

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
  -- Globals
  Vector = require("libs.vector")
  Timer = require("libs.timer")
  _constants = require("src.constants")
  _util = require("libs.util")
  resources = require("libs.cargo").init("resources")
  Concord = require("libs.concord")

  _components = Concord.components
  _systems = Concord.systems
  _worlds = Concord.worlds
  _assemblages = Concord.assemblages

  Concord.loadComponents({"src.components.transform", "src.components.controlled"})
  Concord.loadSystems({"src.systems.motion", "src.systems.input"})
  Concord.loadWorlds({"src.worlds.game"})
  -- Concord.loadAssemblages({})
end

function love.update(dt)
  _worlds.game:emit("update", dt)
end

welcome_text = love.graphics.newText(love.graphics.getFont(), "Time to make a game...")
function love.draw()
  -- Draw filler text
  love.graphics.draw(
    welcome_text,
    love.graphics.getWidth() / 2 - welcome_text:getWidth() / 2,
    love.graphics.getHeight() / 2 - welcome_text:getHeight() / 2
  )

  _worlds.game:emit("draw")
end

function love.keypressed(key, _, _)
  if key == "r" then
    love.event.quit("restart")
  elseif key == "escape" then
    love.event.quit()
  elseif key == "f1" then
    _DEBUG = not _DEBUG
  end

  _worlds.game:emit("keypressed", key)
end

function love.keyreleased(key)
  _worlds.game:emit("keyreleased", key)
end

function love.mousepressed(x, y, button, _, _)
  _worlds.game:emit("mousepressed", x, y, button)
end

function love.mousereleased(x, y, button, _, _)
  _worlds.game:emit("mousereleased", x, y, button)
end

function love.resize(w, h)
  _worlds.world:emit("resize", w, h)
end
