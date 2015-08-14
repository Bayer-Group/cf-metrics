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
    local out_message = string.format("<!channel>\nVM's in %s are utilizing more than 10%% swap\n <http://dockerserver.company.com:3000/dashboard/db/vm-level-stats-prod|Grafana Prod VM Stats>",env)
    ts = read_message("Timestamp")
    alert.set_throttle(9e11)
    alert.send(ts, out_message)
    return 0
end
