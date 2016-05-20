local env = "Cloud"
local alert = require "alert"
local out_message = "blah"
local max_running = 0.1
local max_desired = 0.1
local ratio = 1.0
require "string"
require "math"


function process_message ()
    env = read_message("Fields[Env]")
    if env == nil then
        env = "Cloud"
    end
    desired = read_message("Fields[firehose.analyzer.NumberOfDesiredInstances]")
    if desired == nil then
        desired = 0.0
    end
    running = read_message("Fields[firehose.analyzer.NumberOfRunningInstances]")
    if running == nil then
        running = 0.0
    end

    if desired > 0 and desired > max_desired then
	max_desired = desired
    end 	

    if running > 0 and running > max_running then
	max_running = running
    end    


    ratio = max_running / max_desired
    return 0
end

function timer_event(ns)
    if ratio <= 0.75 and ratio > 0.1 then
       local out_message = string.format("\n Numer of running app instances in %s is %s of desired instances\n <http://grafana-cfmetrics.company.com/dashboard/file/Application_and_Instance_Metrics_NP.json|Grafana App Instances>",env,ratio)
       alert.set_throttle(9e11)
       alert.send(ns, out_message)
    end
    ratio=1.0
    max_running = 0.1
    max_desired = 0.1
end


