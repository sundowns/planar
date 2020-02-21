local phase =
  Concord.component(
  function(e, follow_world_phase, phase)
    assert(follow_world_phase or phase, "phase component must either follow world phase or be explicitly set")
    e.follow_world_phase = follow_world_phase or false
    e.current = phase or nil
  end
)

function phase:set(new_phase)
  self.current = new_phase
end

return phase
