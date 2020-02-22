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

return game
