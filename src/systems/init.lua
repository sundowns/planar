local PATH = (...):gsub("%.init$", "")

return {
  motion = require(PATH .. ".motion"),
  input = require(PATH .. ".input")
}
