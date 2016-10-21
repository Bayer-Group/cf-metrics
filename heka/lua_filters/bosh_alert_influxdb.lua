require "string"

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

   influx_message="blah"
   if string.find(title, "finish") or string.find(title, "error during update") then
     influx_message = string.format("deploy,status=finish,env=%s value=1.0 %.0f", env, ts)
   elseif string.find(title, "begin") then
     influx_message = string.format("deploy,status=begin,env=%s value=1.0 %.0f", env, ts)
   end

   if influx_message ~= "blah" then
   	inject_payload("txt", "bosh-deploy-trigger", influx_message)
   end	  
 return 0
end

