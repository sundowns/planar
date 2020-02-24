local title = Concord.world()

-- ADD SYSTEMS
title:addSystem(_systems.motion)
title:addSystem(_systems.input)
title:addSystem(_systems.title_renderer)
title:addSystem(_systems.spawning)

return title
