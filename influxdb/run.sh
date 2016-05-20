#!/bin/bash
set -m
CONFIG_FILE="/etc/influxdb/influxdb.config"

if [ "${PRE_CREATE_DB}" == "**None**" ]; then
    unset PRE_CREATE_DB
fi

API_URL="http://localhost:8086"

#Pre create database on the initiation of the container
if [ -n "${PRE_CREATE_DB}" ]; then
    echo "=> About to create the following database: ${PRE_CREATE_DB}"
    if [ -f "/data/.pre_db_created" ]; then
        echo "=> Database had been created before, skipping ..."
    else
        echo "=> Starting InfluxDB ..."
        exec /usr/bin/influxd -config=${CONFIG_FILE} &
        PASS=${INFLUXDB_INIT_PWD:-root}
        arr=$(echo ${PRE_CREATE_DB} | tr ";" "\n")

        #wait for the startup of influxdb
        RET=1
        while [[ RET -ne 0 ]]; do
            echo "=> Waiting for confirmation of InfluxDB service startup ..."
            sleep 3 
            curl -k ${API_URL}/ping 2> /dev/null
            RET=$?
        done
        echo ""

        for x in $arr
        do
            echo "=> Creating database: ${x}"
            curl -i -XPOST 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=CREATE DATABASE ${x}"
	    #Pre create the cq's for the databases specified for pre-create on the initiation of the container
	    echo "=> Creating cq for database: ${x}"
            curl -i -XPOST 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=ALTER RETENTION POLICY default ON ${x} DURATION 14d REPLICATION 1 DEFAULT"
            curl -G 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=CREATE RETENTION POLICY one_year ON ${x} DURATION 52w REPLICATION 1"
            curl -G 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=CREATE CONTINUOUS QUERY ${x}_30m ON ${x} BEGIN SELECT mean(value) AS value INTO ${x}.\"one_year\".:MEASUREMENT FROM /.*/ GROUP BY time(30m), * END"
        done
        echo ""

	fg
        exit 0
    fi
else
    echo "=> No database need to be pre-created"
fi

echo "=> Starting InfluxDB ..."

exec /usr/bin/influxd -config=${CONFIG_FILE}
