require "string"
require "math"
local alert = require "alert"
local above_threshold = 0
local total = 0 
local slow = 0
local env = "Cloud"

function process_message ()
    slow = read_message("Fields[firehose.slowConsumerAlert]")
    if slow == nil then
        slow = 2 
    end
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud" 
    end
    if slow > 0 then
       above_threshold = above_threshold + 1
    end
    total=total + 1
    return 0
end

function timer_event(ns)
    if above_threshold > 1 and total > 1 then
       local out_message = string.format("\nSlow consumer alert for Firehose in %s",env)
       alert.set_throttle(9e11)
       alert.send(ns, out_message)
    end  
    total=0
    above_threshold=0
end
