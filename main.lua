local _worlds = nil -- should not have visbility of each other...
local game_started = false
_DEBUG = false

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest", 8)
  audio_ambience = love.audio.newSource("resources/audio/pulsing2.wav", "stream")
  Vector = require("libs.vector")
  Timer = require("libs.timer")
  _constants = require("src.constants")
  _util = require("libs.util")
  HC = require("libs.HC")
  Concord = require("libs.concord")
  moonshine = require("libs.moonshine")
  _sprites = require("src.sprites")
  love.window.setIcon(love.image.newImageData("resources/sprites/ship_blue.png"))

  _fonts = {
    ["SCORE_COUNTER"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 48),
    ["FINAL_SCORE"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 36),
    ["RESTART"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 24)
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
  audio_ambience:setLooping(true)
  love.audio.play(audio_ambience)
  _worlds.game:emit("set_collision_world", "RED", HC.new())
  _worlds.game:emit("set_collision_world", "BLUE", HC.new())
  -- Assemble the player entity
  _assemblages.player:assemble(
    Concord.entity(_worlds.game),
    Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  )
  audio_bgm = love.audio.newSource("resources/audio/bgm.wav", "stream")
  audio_bgm:setLooping(true)
end

function love.update(dt)
  if game_started then
    _worlds.game:emit("update", dt)
  else
    _worlds.title:emit("update", dt)
  end
end

function love.draw()
  if game_started then
    _worlds.game:emit("draw")
    _worlds.game:emit("draw_ui")
  else
    _worlds.title:emit("draw")
    _worlds.title:emit("draw_ui")
  end
end

function love.keypressed(key, _, _)
  if key == "r" then
    -- love.event.quit("restart")
  elseif key == "escape" then
    love.event.quit()
  elseif key == "f1" then
    -- _DEBUG = not _DEBUG
  elseif key == "space" then
    if game_started then
      _worlds.game:emit("attempt_phase_shift")
    else
      game_started = true
      love.audio.stop(audio_ambience)
      love.audio.play(audio_bgm)
      _worlds.game:emit("phase_update", "RED")
      _worlds.game:emit("begin_wave")
    end
  end

  if game_started then
    _worlds.game:emit("keypressed", key)
  else
    _worlds.title:emit("keypressed", key)
  end
end

function love.keyreleased(key)
  if game_started then
    _worlds.game:emit("keyreleased", key)
  else
    _worlds.title:emit("keyreleased", key)
  end
end

function love.mousepressed(x, y, button, _, _)
  if game_started then
    _worlds.game:emit("mousepressed", x, y, button)
  else
    _worlds.title:emit("mousepressed", x, y, button)
  end
end

function love.mousereleased(x, y, button, _, _)
  if game_started then
    _worlds.game:emit("mousereleased", x, y, button)
  else
    _worlds.title:emit("mousereleased", x, y, button)
  end
end

function love.resize(w, h)
  _worlds.game:emit("resize", w, h)
  _worlds.title:emit("resize", w, h)
end
