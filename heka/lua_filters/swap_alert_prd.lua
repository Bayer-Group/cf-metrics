local env = "Cloud"
local alert = require "alert"
local out_message = "blah"
require "string"

function process_message ()
    percent = read_message("Fields[system_swap_percent]")
    if percent == nil then
        percent = 200 
    end
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud" 
    end
    local out_message = string.format("\nVM's in %s are utilizing more than 25%% swap\n <http://grafana-cfmetrics.company.com/dashboard/file/vm-level-stats-prd.json|Grafana Prod VM Stats>",env)
    ts = read_message("Timestamp")
    alert.set_throttle(4e12)
    alert.send(ts, out_message)
    return 0
end
