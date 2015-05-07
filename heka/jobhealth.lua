
local alert = require "alert"
require "string"

function process_message ()
   local out_message = "Something is not healthy"
   local ts = read_message("Timestamp")
   -- 15 minutes
   alert.set_throttle(9e11)
   alert.send(ts, out_message)
   return 0
end
