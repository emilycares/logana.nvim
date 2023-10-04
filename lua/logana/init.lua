local error_handling = require("logana.error_handling")
local analyze = require("logana.analyze")

return {
  set_qfl = error_handling.set_qfl,
  analyze = analyze
}
