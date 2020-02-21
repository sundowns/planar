-- Draws polygonal shapes to the screen
local spawning = Concord.system()

function spawning:init()
  self.wave_active = false
  self.wave_timer = Timer.new()
end

function spawning:begin_wave()
  self.wave_timer:clear()
  self.wave_active = true
  self.wave_timer:every(
    3,
    function()
      Concord.assemblages.obstacle:assemble(
        Concord.entity(Concord.worlds.game),
        Vector(love.math.random(0, love.graphics.getWidth()), 0),
        Vector(0, 10),
        _util.g.choose("RED", "BLUE"),
        _util.g.choose("TRIANGLE", "SQUARE"),
        love.math.random(1.25, 3.5),
        love.math.random(0, 2)
      )
    end
  )
end

function spawning:update(dt)
  self.wave_timer:update(dt)
end

return spawning
