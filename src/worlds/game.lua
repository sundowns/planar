local game = Concord.world()

-- ADD SYSTEMS
game:addSystem(_systems.motion)
game:addSystem(_systems.input)
game:addSystem(_systems.renderer)

return game
