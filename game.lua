game = {}
local _worlds = nil -- should not have visbility of each other...
local game_started = false
_DEBUG = false

function game:init()
  Concord = require("libs.concord")
  _components = Concord.components
  _systems = Concord.systems
  _worlds = Concord.worlds
  _assemblages = Concord.assemblages

  Concord.loadComponents("src/components")
  Concord.loadSystems("src/systems")
  Concord.loadWorlds("src/worlds")
  Concord.loadAssemblages("src/assemblages")

  love.audio.play(_audio["AMBIENCE"])
  _worlds.game:emit("set_collision_world", "RED", HC.new())
  _worlds.game:emit("set_collision_world", "BLUE", HC.new())
  -- Assemble the player entity
  _assemblages.player:assemble(
    Concord.entity(_worlds.game),
    Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  )
end

function game:update(dt)
  if game_started then
    _worlds.game:emit("update", dt)
  else
    _worlds.title:emit("update", dt)
  end
end

function game:draw()
  if game_started then
    _worlds.game:emit("draw")
    _worlds.game:emit("draw_ui")
  else
    _worlds.title:emit("draw")
    _worlds.title:emit("draw_ui")
  end
end

function game:keypressed(key, _, _)
  if key == "r" then
    -- love.event.quit("restart")
  elseif key == "escape" then
    -- love.event.quit()
  elseif key == "f1" then
    -- _DEBUG = not _DEBUG
  elseif key == "space" then
    if game_started then
      _worlds.game:emit("attempt_phase_shift")
    else
      game_started = true
      love.audio.stop(_audio["AMBIENCE"])
      love.audio.play(_audio["BGM"])
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

function game:keyreleased(key)
  if game_started then
    _worlds.game:emit("keyreleased", key)
  else
    _worlds.title:emit("keyreleased", key)
  end
end

function game:mousepressed(x, y, button, _, _)
  if game_started then
    _worlds.game:emit("mousepressed", x, y, button)
  else
    _worlds.title:emit("mousepressed", x, y, button)
  end
end

function game:mousereleased(x, y, button, _, _)
  if game_started then
    _worlds.game:emit("mousereleased", x, y, button)
  else
    _worlds.title:emit("mousereleased", x, y, button)
  end
end

function game:resize(w, h)
  _worlds.game:emit("resize", w, h)
  _worlds.title:emit("resize", w, h)
end
