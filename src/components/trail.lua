local MAX_PARTICLES = 20
local trail =
  Concord.component(
  function(e, spritesheet, quads)
    e.system = love.graphics.newParticleSystem(spritesheet, MAX_PARTICLES)
    e.system:setQuads(quads)
    e.system:stop()
    e.system:setEmissionRate(2)
    e.system:setSizes(1)
    e.system:setParticleLifetime(0.5, 2)
  end
)

function trail:start()
  self.system:start()
end

function trail:stop()
  self.system:stop()
end

function trail:draw(position)
  love.graphics.draw(self.system, position.x, position.y, 0, 5, 5)
end

-- offset from where the particle system is being drawn
function trail:update(dt, offset, direction_angle)
  self.system:setPosition(offset.x, offset.y)
  self.system:setDirection(3) -- WIP: figuring this out
  self.system:update(dt)
end

return trail
