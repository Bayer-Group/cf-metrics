require "string"
require "math"
local alert = require "alert"
local total = 0 

function process_message ()
    total=total + 1
    return 0
end

function timer_event(ns)
    if total < 1 then
       local out_message = string.format("\nNo data from producer Bosh Monitor for Prod in last 5 minutes")
       alert.set_throttle(4e12)
       alert.send(ns, out_message)
    end  
    total=0
end
