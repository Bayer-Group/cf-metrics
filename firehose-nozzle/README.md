Create the go executable and config file from https://github.com/evoila/influxdb-firehose-nozzle


export GOPATH=~/work
export PATH=$GOPATH:$PATH
cd $GOPATH
go get -u -v github.com/evoila/influxdb-firehose-nozzle
cd $GOPATH/src/github.com/evoila/influxdb-firehose-nozzle
go build .
./influxdb-firehose-nozzle -config config/influxdb-firehose-nozzle.json 

Once that is working copy the config and executable to this folder to make the container


