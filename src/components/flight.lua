local flight =
  Concord.component(
  function(e, acceleration)
    e.acceleration = acceleration
  end
)

return flight
