require "string"
require "math"
local alert = require "alert"
local above_threshold = 0
local total = 0 
local ratio = 3.0
local env = "Cloud"

function process_message ()
    ratio = read_message("Fields[available_memory_ratio]")
    if ratio == nil then
        ratio = 2.0 
    end
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud" 
    end
    if ratio > 0.20 then
       above_threshold = above_threshold + 1
    end
    total=total + 1
    return 0
end

function timer_event(ns)
    if above_threshold < 1 and total > 1 then
       local out_message = string.format("<!channel>\nNo DEA's in %s have more than 20%% memory\n <http://stlucfutilprd01.monsanto.com:3000/dashboard/db/dea-stats-nonprod|Grafana NP DEA Stats>",env)
       alert.set_throttle(9e11)
       alert.send(ns, out_message)
    end  
    total=0
    above_threshold=0
end
