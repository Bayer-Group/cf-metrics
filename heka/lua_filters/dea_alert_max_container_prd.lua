require "string"
require "math"
local alert = require "alert"
local above_threshold = 0
local total = 0 
local env = "Cloud"
local freemem = "20000"

function process_message ()
    freemem = read_message("Fields[firehose.DEA.remaining_memory]")
    if freemem == nil then
        freemem = 20000 
    end
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud" 
    end
    if freemem > 3072 then
       above_threshold = above_threshold + 1
    end
    total=total + 1
    return 0
end

function timer_event(ns)
    if above_threshold < 1 and total > 1 then
       local out_message = string.format("<!subteam^S0EA44MLN|gcloudops>\nNo DEA's in %s have room for a 3GB container\n <http://grafana-cfmetrics.company.com/dashboard/file/dea-prd.json|Grafana PRD DEA Stats>",env)
       alert.set_throttle(9e11)
       alert.send(ns, out_message)
    end  
    total=0
    above_threshold=0
end
