local env = "Cloud"
local healthy = 2
local job = "notfound"
local id = "12345678-abcd-1234-abcd-1234567890ab"
local alert = require "alert"
local out_message = "blah"
local send_alert = 0
local pair = "unknown"
local issues = {}
local list = " "
require "string"
require "math"


function process_message ()
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud"
    end
    healthy = read_message("Fields[system_healthy]")
    if healthy == nil then
        healthy = 2.0
    end
    job = read_message("Fields[Job]")
    if job == nil then
        job = "notfound"
    end
    id = read_message("Fields[Id]")
    if id == nil then
       id = "12345678-abcd-1234-abcd-1234567890ab"
    end

    if healthy < 1.0 then
       pair=job .. "_" .. id
       if issues[pair] then
           issues[pair] = issues[pair] + 1
           if issues[pair] > 5 then
		send_alert = send_alert + 1
	   end
       else
           issues[pair] = 1 
       end
    end
    return 0
end

function timer_event(ns)
    if send_alert > 0 then
       for key,value in pairs(issues) do
           if value > 5 then
              list = key .. " , " .. list
	   end
       end	
       local out_message = string.format("\nComponent\(s\) of %s no longer healthy\n %s\n <http://grafana-cfmetrics.company.com/dashboard/file/component-health-np.json|Grafana NP Health>",env,list)
       alert.set_throttle(9e11)
       alert.send(ns, out_message)
    end
    send_alert=0
    issues={}
    pair="unknown"
    list=" "
end


