local env = "Cloud"
local alert = require "alert"
require "string"

function process_message ()
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud"
    end
   local out_message = string.format("A component of %s is no longer healthy",env)
   local ts = read_message("Timestamp")
   -- 15 minutes
   alert.set_throttle(9e11)
   alert.send(ts, out_message)
   return 0
end
