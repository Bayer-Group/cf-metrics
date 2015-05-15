--[[
Monsanto wrapper over Heka Anomaly Detection module to 
translate individual algorithms to a friendly name. 
This should make it easier to configure anomaly algorithms without know a the data science behind the
algorithms

--]]

require("string")

function trnslt_anomaly_config(pl,mon_cfg,win,hwin )
   local payl = pl or 'stats'
   local mon_anomaly_config = mon_cfg or 'spikes:1 slowchange:1'

   local t_anomcfg = {}
   for k,v in string.gmatch(mon_anomaly_config,"(%w+):(%d+)")  do t_anomcfg[k] = v end
   local a_fld = ''
   local a_anomcfg = ' '
   local ky = ''
   local anon_str = ''

   for k in pairs(t_anomcfg)
     do
       local a_fld = t_anomcfg[k] or ''
       ky = string.lower(k)
    
       if ky == 'spikes' then
         anon_str = 'roc("' .. payl .. '",' .. a_fld .. ','.. win .. ',' .. hwin ..',2,false,true)'
       elseif ky == 'slowchange' then
         anon_str = 'mww("' .. payl .. '",' .. a_fld .. ','.. win .. ',' .. hwin ..',0.001,any)'
       elseif ky == 'creepingchange' then
         anon_str = 'mww_nonparameteric("'.. payl .. '",' .. a_fld .. ','.. win .. ',' .. hwin ..',0.60)'
       elseif ky == 'breakout' then
         anon_str = ''
       elseif ky == 'breakdown' then
         anon_str = 'roc("' .. payl .. '",' .. a_fld .. ',3,0,1,true,false)'
       elseif ky == 'threshold' then
         anon_str = ' '
       end
       a_anomcfg = a_anomcfg .. ' ' .. anon_str
    end  
    return a_anomcfg
  end
 
--Test Code
--[[
a_cfg = trnslt_anomaly_config(nil,nil)
print(a_cfg)
--]]
-- end test code
