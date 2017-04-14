#!/bin/bash
set -m
CONFIG_FILE="/etc/influxdb/influxdb.config"

if [ "${PRE_CREATE_DB}" == "**None**" ]; then
    unset PRE_CREATE_DB
fi

API_URL="http://localhost:8086"

if [ -f "/data/.pre_db_created" ]
then
	echo "reusing existing local data ..."
else
	# check if a backup exists to restore from
        aws s3 ls ${BUCKET_ROOT}/InfluxBackups/ | grep $STACK_NAME
        if [ $? -eq 0 ]
        then
		cd /data
                echo "found existing backup. pulling"
                DATA=`aws s3 ls $BUCKET_ROOT/InfluxBackups/ | grep $STACK_NAME | sort | tail -n 1 | awk -F' ' '{ print $4}'`
                aws --region us-east-1 s3 cp $BUCKET_ROOT/InfluxBackups/$DATA .
                tar -xvf $DATA --strip-components=2
		
		# restore the data in /data/temp
		influxd restore -metadir /data/meta /data/temp/
		arr=$(echo ${PRE_CREATE_DB} | tr ";" "\n")
        	for x in $arr
        	do
			influxd restore -database ${x} -datadir /data/db /data/temp
		done
		touch "/data/.pre_db_created"
        else
                echo "no backup found in s3, starting from scratch"
	fi
fi

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
            curl -G 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=CREATE DATABASE ${x}"
	    #Pre create the cq's for the databases specified for pre-create on the initiation of the container
	    echo "=> Creating cq for database: ${x}"
            curl -i -XPOST 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=ALTER RETENTION POLICY autogen ON ${x} DURATION 14d REPLICATION 1 DEFAULT"
            curl -G 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=CREATE RETENTION POLICY one_year ON ${x} DURATION 52w REPLICATION 1"
            curl -G 'http://localhost:8086/query?u=root&p=root' --data-urlencode "q=CREATE CONTINUOUS QUERY ${x}_30m ON ${x} BEGIN SELECT mean(value) AS value INTO ${x}.\"one_year\".:MEASUREMENT FROM /.*/ GROUP BY time(30m), * END"
        done
        echo ""

        touch "/data/.pre_db_created"
        fg
        exit 0
    fi
else
    echo "=> No database need to be pre-created"
fi

echo "=> Starting InfluxDB ..."

exec /usr/bin/influxd -config=${CONFIG_FILE}
