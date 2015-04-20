require "string"

total = 0 --preserved between restarts since it is in the global space
local count = 0 -- local scope so not preserved between restarts

deas = {}

function process_message ()
    local ratio = read_message("Fields[Value]")
    local ip =  read_message("Fields[IP]")
    local dea = deas[ip]
    if ratio < "0.84" then
       count = count + 1
       deas[ip] = ratio
    end
    total = total + 1
    return 0
end

function timer_event(ns)
    add_to_payload("#deas\tip\tratio\n")
    for k, v in pairs(deas) do
        add_to_payload(string.format("%s\t%d\n", k, v))
    end
    inject_payload("txt", "", 
                    string.format("%d messages in the last minute for DEA's with less than 84% memory; %d had less than 88%\nThey", count, total))
end
