require "string"
local title = "unknown"
local influx_message = "blah"

function process_message ()
    title = read_message("Fields[Title]")
    if title == nil then
        title = "unkown"
    end
   ts = read_message("Fields[Tstamp]")
  -- make output like: 5MinAvg,Hostname=myhost,Environment=dev value=0.110000 1434932024
   env = read_message("Fields[Env]") 
   if env == nil then
       env = "unknown"
   end

   if string.find(title, "finish") or string.find(title, "error during update") then
     influx_message = string.format("deploy,status=finish,env=%s value=1.0 %.0f", env, ts)
   elseif string.find(title, "begin") then
     influx_message = string.format("deploy,status=begin,env=%s value=1.0 %.0f", env, ts)
   end

   inject_payload("txt", "bosh-deploy-trigger", influx_message)
   return 0
end

