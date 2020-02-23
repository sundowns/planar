local _worlds = nil -- should not have visbility of each other...
_DEBUG = false

function love.load()
  local bgm = love.audio.newSource("resources/audio/bgm.wav", "stream")
  Vector = require("libs.vector")
  Timer = require("libs.timer")
  _constants = require("src.constants")
  _util = require("libs.util")
  HC = require("libs.HC")
  Concord = require("libs.concord")
  moonshine = require("libs.moonshine")

  _fonts = {
    ["SCORE_COUNTER"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 32),
    ["GAME_OVER"] = love.graphics.newFont("resources/fonts/venus rising rg.ttf", 32),
    ["FINAL_SCORE"] = love.graphics.newFont("resources/fonts/Xolonium-Regular.ttf", 24)
  }

  _components = Concord.components
  _systems = Concord.systems
  _worlds = Concord.worlds
  _assemblages = Concord.assemblages

  Concord.loadComponents("src/components")
  Concord.loadSystems("src/systems")
  Concord.loadWorlds("src/worlds")
  Concord.loadAssemblages("src/assemblages")

  --https://hc.readthedocs.io/en/latest/MainModule.html#initialization
  _worlds.game:emit("set_collision_world", "RED", HC.new())
  _worlds.game:emit("set_collision_world", "BLUE", HC.new())

  bgm:setLooping(true)
  love.audio.play(bgm)
  -- Assemble the player entity
  _assemblages.player:assemble(
    Concord.entity(_worlds.game),
    Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  )
  _worlds.game:emit("phase_update", "RED")
  _worlds.game:emit("begin_wave")
end

function love.update(dt)
  _worlds.game:emit("update", dt)
end

function love.draw()
  _worlds.game:emit("draw")

  _worlds.game:emit("draw_ui")
end

function love.keypressed(key, _, _)
  if key == "r" then
    -- love.event.quit("restart")
  elseif key == "escape" then
    love.event.quit()
  elseif key == "f1" then
    -- _DEBUG = not _DEBUG
  elseif key == "space" then
    _worlds.game:emit("attempt_phase_shift")
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
  _worlds.game:emit("resize", w, h)
end
