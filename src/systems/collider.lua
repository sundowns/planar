local collider =
  Concord.system(
  {_components.collides, _components.transform, _components.polygon},
  {_components.collides, _components.transform, _components.polygon, _components.control, "PLAYER"}
)

function collider:init()
  self.current_phase = nil
  self.collision_worlds = {}

function collider:player_collided()
  self:disable()
end

function collider:onEntityAdded(e)
  -- check if entity has a phase component:
  if e:has(_components.phase) then
  self.pool.onEntityRemoved = function(pool, e)
    local phase = e:get(_components.phase)
    if phase then
      assert(
        self.collision_worlds[phase.current],
        "collision_worlds to add entity to non-existent collision world: " .. phase.current
      )
      self.collision_worlds[phase.current]:remove(e:get(_components.collides).hitbox)
    end
  end

  self.pool.onEntityAdded = function(pool, e)
    -- check if entity has a phase component:
    if e:has(_components.phase) then
      local phase = e:get(_components.phase)
      assert(
        self.collision_worlds[phase.current],
        "collision_worlds to add entity to non-existent collision world: " .. phase.current
      )

      local collides = e:get(_components.collides)
      local polygon = e:get(_components.polygon)
      local transform = e:get(_components.transform)
      -- fuck me ey
      collides:set_hitbox(
        self.collision_worlds[phase.current]:polygon(unpack(polygon:calculate_world_vertices(transform.position)))
      )
    else
      -- add it to the neutral world?
    end
  end
end

function collider:set_collision_world(phase, collision_world)
  self.collision_worlds[phase] = collision_world
end

function collider:phase_update(new_phase)
  self.current_phase = new_phase
end

function collider:update(_)
  for i = 1, self.pool.size do
    self:update_entity(self.pool:get(i))
  end

  for i = 1, self.PLAYER.size do
    local player = self.PLAYER:get(i)
    local collides = player:get(_components.collides)
    local transform = player:get(_components.transform)
    for shape, delta in pairs(self.collision_worlds[self.current_phase]:collisions(collides.hitbox)) do
      self:getWorld():emit("player_collided")
    end
  end
end

function collider:draw()
  if not _DEBUG then
    return
  end
  love.graphics.setColor(0, 1, 0)
  for i = 1, self.pool.size do
    local collides = self.pool:get(i):get(_components.collides)
    if collides.hitbox then
      collides.hitbox:draw()

      -- draw centre point
      local position = self.pool:get(i):get(_components.transform).position
      love.graphics.circle("fill", position.x + collides.offset.x, position.y + collides.offset.y, 2)
    end
  end
  _util.l.resetColour()
end

-- Used to moving tiles & hazards (only hazards are used)
function collider.update_entity(_, e)
  local position = e:get(_components.transform).position
  local collides = e:get(_components.collides)
  local polygon = e:get(_components.polygon)

  if collides.hitbox then
    collides.hitbox:moveTo(position.x + collides.offset.x, position.y + collides.offset.y)
  end
end

return collider
