
local alert = require "alert"
require "string"

function process_message ()
   local out_message = "Something is not healthy"
   local ts = read_message("Timestamp")
   alert.set_throttle(60e9)
   alert.send(ts, out_message)
   return 0
end
