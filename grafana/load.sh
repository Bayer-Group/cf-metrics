#!/bin/sh

UP=0

while [ $UP -ne 1 ]
do
	curl localhost:3000 &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "localhost was up"
		UP=1
	fi
	echo "waiting for host to come up ......"
	sleep 2
done

curl --user admin:admin 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"cf_np","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"cf_np","user":"root","password":"root"}'
curl --user admin:admin 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"cf_prd","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"cf_prd","user":"root","password":"root"}'
curl --user admin:admin 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"bosh_np","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"bosh_np","user":"root","password":"root"}'
curl --user admin:admin 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"bosh_prd","type":"influxdb","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"bosh_prd","user":"root","password":"root"}'
