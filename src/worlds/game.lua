local game = Concord.world()

-- ADD SYSTEMS
game:addSystem(_systems.motion)
game:addSystem(_systems.input)
game:addSystem(_systems.renderer)
game:addSystem(_systems.flight)
game:addSystem(_systems.phasing)
game:addSystem(_systems.spawning)
game:addSystem(_systems.collider)
game:addSystem(_systems.score)

-- insane hack cause I don't know how tf to do this with concord anymore, pretty much circumventing the pool sytem :c
function game:onEntityAdded(e)
  if e:has(_components.phase) then
    game:getSystem(_systems.phasing):onEntityAdded(e)
  end

  if e:has(_components.collides) and e:has(_components.transform) and e:has(_components.polygon) then
    game:getSystem(_systems.collider):onEntityAdded(e)
  end
end

return game
