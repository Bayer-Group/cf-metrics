local env = "Cloud"
local alert = require "alert"
local out_message = "blah"
require "string"

function process_message ()
    percent = read_message("Fields[system_disk_persistent_percent]")
    if percent == nil then
        percent = 200 
    end
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud" 
    end
    local out_message = string.format("<!channel>\nVM's in %s are utilizing more than 85%% of their persistent disk\n <http://dockerserver.company.com:3000/dashboard/db/vm-level-stats-prod|Grafana Prod VM Stats>",env)
    ts = read_message("Timestamp")
    --- roughly 1 day throttle
    alert.set_throttle(1e14)
    alert.send(ts, out_message)    
    return 0
end
