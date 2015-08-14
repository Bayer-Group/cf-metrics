local env = "Cloud"
local alert = require "alert"
local out_message = "blah"
require "string"

function process_message ()
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud"
    end
    out_message = string.format("<!channel>\n A component of %s is no longer healthy\n <http://dockerserver.company.com:3000/dashboard/db/component-health-prod|Grafana Prod Health>",env)
    ts = read_message("Timestamp")
    -- 15 minutes
    alert.set_throttle(9e11)
    alert.send(ts, out_message)
    return 0
end
