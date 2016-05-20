curl --user admin:admin 'http://server.company.com:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"cf_np","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"cf_np","user":"root","password":"root"}'
curl --user admin:admin 'http://server.company.com:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"cf_prd","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"cf_prd","user":"root","password":"root"}'
curl --user admin:admin 'http://server.company.com:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"bosh_np","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"bosh_np","user":"root","password":"root"}'
curl --user admin:admin 'http://server.company.com:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"bosh_prd","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"bosh_prd","user":"root","password":"root"}'

curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Application_and_Instance_Metrics_NP.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Application_and_Instance_Metrics_PRD.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Component_Health_NP.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Component_Health_PRD.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @DEA_stats_NP.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @DEA_stats_PRD.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Routing_NP.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Routing_PRD.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @Users.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @VM_Level_Stats_NP.json
curl --user admin:admin 'http://server.company.com:3000/api/dashboards/db' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary @VM_Level_Stats_PRD.json
