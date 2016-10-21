local job = "notfound"
local id = "12345678-abcd-1234-abcd-1234567890ab"
local alert = require "alert"
local out_message = "blah"
local total = 0
local loop_total = 0
local pair = "unknown"
local leaders = {}
local loop = 0
require "string"
require "math"

function process_message ()
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud"
    end
    job = read_message("Fields[Job]")
    if job == nil then
        job = "notfound"
    end
    id = read_message("Fields[Id]")
    if id == nil then
       id = "12345678-abcd-1234-abcd-1234567890ab"
    end

    pair=job .. "_" .. id
    if leaders[pair] then
        leaders[pair] = leaders[pair] + 1
    else
        leaders[pair] = 1
        loop_total = loop_total + 1
    end

    return 0
end

-- looks for two different etcd instances which both say they are leader.  Run two timer intervals and only alert if there are multiple leaders seen for two intervals in a row.
function timer_event(ns)
    -- if there were more than 1 leader in the last loop, and add to the overall total
    loop = loop + 1
    if loop_total > 1 then
       total = total + 1
    end
    -- if this is the 2nd loop, and there was a match in both loops send an alert
    if loop > 1 then
        if total > 1 then
		local out_message = string.format("\nMore than one Etcd leader in %s, possible split brain cluster\n <http://grafana-cfmetrics.company.com/dashboard/file/Etcd_stats_PRD.json|Etcd PRD Stats>",env)
       		alert.set_throttle(4e12)
       		alert.send(ns, out_message)
	end
	-- reset the total count and loop count
	loop=0
	total=0
    end

    -- reset individual loop total and strings
    loop_total=0
    leaders={}
    pair="unknown"
end

