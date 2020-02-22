local charge =
  Concord.component(
  function(e, max_charge)
    e.max_charge = max_charge
    e.current_charge = max_charge
  end
)

return charge
