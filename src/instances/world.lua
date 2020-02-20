local world = Instance()

-- local example = _systems.example()

-- ADD SYSTEMS

-- world:addSystem(example, "update")
-- world:addSystem(example, "draw")

-- ENABLE SYSTEMS

-- world:enableSystem(example, "draw")

function world.enable_updates()
  -- world:enableSystem(example, "update")
end

function world.disable_updates()
  -- world:disableSystem(example, "update")
end

world.enable_updates()

return world
