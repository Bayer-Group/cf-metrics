#cf-metrics
A project for monitoring and alerting with cloudfoundry utilizing the [CF loggregator](https://docs.cloudfoundry.org/loggregator/architecture.html), [a firehose nozzle](https://github.com/evoila/influxdb-firehose-nozzle), [BOSH monitor](https://bosh.io/docs/monitoring.html), [heka](https://github.com/mozilla-services/heka), [influxdb](https://github.com/influxdb/influxdb), and [grafana](https://github.com/grafana/grafana)

_***This branch is for consuming metrics from the Loggregator firehose.  If you are on cf release which is older than v233 please use the collector branch of this project._***

## Why
Monitoring and alerting are critical features for any platform which supports non-trival workloads.  Cloudfoundry provides various components which monitor and track the health of its Key Performance Indicators (KPI's) but for the most part it lacks an out-of-the-box solution which ties all these components together.  There are some existing blog posts ([example](http://blog.pivotal.io/pivotal-cloud-foundry/products/monitoring-pivotal-cloud-foundry-health-and-status-hybrid-models-kpis-and-more)) which provide solutions to this issue, but they tend to rely on closed-source proprietary components.  The goal of this project is to provide a comprehensive solution for CF monitoring and alerting based solely on open source projects.  

## Architecture and Data Flow
### Architecture
![](images/architecture.png)

| Component     | Purpose     |
| ------------- |-------------|
| Loggregator Firehose | collects logs, events, and metrics from all jobs and app containers in cf - [details](https://docs.cloudfoundry.org/loggregator/architecture.html) |
| Firehose Nozzle  | connects to the Firehose and forwards metrics to heka  - [details](https://github.com/evoila/influxdb-firehose-nozzle) |
| Bosh HM       | collects vm vitals for all vm's in the cf release - [details](https://bosh.io/docs/monitoring.html) |
| Heka          | stream processer for metrics from collector and HM to use for monitoring, alerting, and anomaly detection - [details](http://hekad.readthedocs.org/en/v0.9.2/)  |
| Influxdb      | open source time series database for persistent storage of metric data streams - [details](http://influxdb.com/docs/v0.9/introduction/overview.html) |
| Grafana       | the leading metrics dashboard for influxdb - [details](http://grafana.org/) |
| Slack         | team collaboration and communication tool.  Chatops for alerts- [details](https://slack.com/) |

For this project we have packaged the heka, influxdb, firehose nozzle, and grafana components into a [docker compose](https://docs.docker.com/compose/) enviornment to allow for a compact and easily portable solution.

### Data Flow
The Loggregator and BOSH monitor compoents gather metrics from all cf jobs as well as OS statistics from all bosh controlled VM's via local agents.  BOSH monitor is configured to forward data directly to heka in graphite and consul format (depending on metric type).  A firehose nozzle application is started and configured to stream metric data off the Loggreator firehose and push it to heka.  Heka decodes these inputs and streams them through multiple filters for anomaly detection and threshold based alerting.  The relevant data from the streams also gets forwarded to influxdb for persistence and dashbaords available through grafana.  Any alerts or anomalies which get detected in the heka sandboxes get encoded and sent to a configured slack channel for chatops.

## Setup
To run the project, you will need the following:

1.  A working bosh/cloud-foundry enviornment (cf release >= v233 and bosh >= v255.4)
2.  A docker host with [docker](https://docs.docker.com/installation/ubuntulinux/) and [docker compose](https://docs.docker.com/compose/#installation-and-set-up) installed and configured.  This project has been tested with docker v1.8.3 and docker-compose v1.4.2

### Docker Host and Container Configuration 
First clone this repo to the docker host and change the following files to reflect your enviornment:

#### Compose Configuration
cf-metrics->docker-compose.yml: update this list to reflect the names of your cf enviornment(s) yml parameter for "deployment name"
```
  environment:
  - PRE_CREATE_DB=cf_prd;cf_np;bosh_prd;bosh_np  
```
#### Nozzle Configuration
The firehose nozzle is configured via enviornment variables in the docker-compose.yml.  Variables passed here override the ones built inside the nozzle cotainer via the nozzle json file.  At a minimum, you will want to change these four variables to reference your cf deployment:
```
  NOZZLE_UAAURL=https://uaa.cf-np.company.com
  NOZZLE_PASSWORD=secret
  NOZZLE_TRAFFICCONTROLLERURL=wss://doppler.cf-np.company.com:443
  NOZZLE_DEPLOYMENT=cf_aws_np
```
Additional enviornment variable options can be found in the [upstream project](https://github.com/evoila/influxdb-firehose-nozzle)

#### Heka Configuration
cf-metrics->heka->heka.toml: update the following sections to reflect your enviornment(s) based on the comments in the file.  Or comment them out if you don't want any of the specific alerts
```
[recieving-boshhm-filter-np]
[recieving-boshhm-filter-prd]
[recieving-firehose-filter-np]
[recieving-firehose-filter-prd]
[bosh-alert-influx-filter]
[bosh-alert-slack-filter]
[Cell_Max_Container_NP]
[Cell_Avail_Mem_NP]
[Etcd_Leader_NP]
[Cell_Max_Container_PRD]
[Cell_Avail_Mem_PRD]
[Etcd_Leader_PRD]
[DEA_Max_Container_NP]
[DEA_Max_Container_PRD]
[DEA_Avail_Mem_NP]
[DEA_Avail_Mem_PRD]
[Job_Health_NP]
[Job_Health_PRD]
[Firehose_Slow_Consumer_NP]
[Firehose_Slow_Consumer_PRD]
[Bosh_CPU_Wait_NP]
[Bosh_CPU_Wait_PRD]
[App_Health_NP]
[App_Health_PRD]
[Bosh_Swap_Prd]
[Bosh_Swap_NP]
[Bosh_Disk_Notify_Prd]
[Bosh_Disk_Notify_NP]
[influxdb-filter-cf-np]
[influxdb-filter-cf-np.config]
[influxdb-filter-cf-prd]
[influxdb-filter-cf-prd.config]
[influxdb-filter-bosh-np]
[influxdb-filter-bosh-np.config]
[influxdb-filter-bosh-prd]
[influxdb-filter-bosh-prd.config]
[SlackEncoder.config]
[influxdb-output-bosh-alerts-np]
[influxdb-output-bosh-alerts-prd]
[influxdb-output-cf-np]
[influxdb-output-cf-prd]
[influxdb-output-bosh-np]
[influxdb-output-bosh-prd]
```

cf-metrics->heka->lua_filters->``*.lua``: If you are using the built in lua filter alerts, you will have to update the url in the lua code to point to the fqdn of your docker host.  For example:
```
  local out_message = string.format("<!channel>\nNo DEA's in %s have more than 10%% memory\n <http://dockerserver.company.com:3000/dashboard/db/dea-stats-nonprod|Grafana NP DEA Stats>",env)
```

#### Firehose Nozzle Configuration
cf-metrics->firehose-nozzle->influxdb-firehose-nozzle-*.json

For each CloudFoundry deployment that you'll be monitoring, you'll need a nozzle defined in the docker-compose.yml file and a corresponding nozzle configuration file.  Update the parameters in the nozzle json as explained in the [upstream project](https://github.com/evoila/influxdb-firehose-nozzle)

#### Grafana Configuration
cf-metrics->grafana->grafana.ini: update the following section to reflect the fqdn of your docker host:
```
 # The public facing domain name used to access grafana from a browser
 domain = server.company.com
```

#### Running the Compose Application
In the top level of the project directory, use the following command to create the docker compose application and verify successful start:
```
 docker-compose up -d && docker-compose ps
```

### BOSH & Cloud Foundry Setup
_*** Bosh/CF will complain if you configure an endpoint which is not currently listening for connections.  Make sure you have the heka container running and listening on the configured ports before you update your bosh and cf deployments***_

Update the following section in your bosh manifest and redeploy bosh to enable the bosh monitor statistics:
```
graphite_enabled: true
    graphite:
      address: <ip of your docker host>
      port: 2004
      prefix: bosh-prod
    consul_event_forwarder_enabled: true
    consul_event_forwarder:
      host: <ip of your docker host>
      port: 8500
      protocol: http
      events: true
      heartbeats_as_alerts: false
```

Update the following section in your cloud foundry manifest and redeploy cf to enable a uaa client for the firehose nozzle:
```
properties:
  uaa:
    clients:
      influxdb-firehose-nozzle:
        access-token-validity: 1209600
        authorized-grant-types: authorization_code,client_credentials,refresh_token
        override: true
        secret: <password>
        scope: openid,oauth.approvals,doppler.firehose
        authorities: oauth.login,doppler.firehose
```
## Usage
Before you can use grafana to show metrics you need to configure datasources for it to querry and create dashboards.  You can do this manually via the UI or by following the example api requests included in the cf-metrics->grafana->README.md file.  These examples will configure the datasource for influxdb and import some stored dashboards which show relevant cf and bosh metric data. 

After configuring the datastores you should have a bosh and cf database for each enviornment you're monitoring
![](images/datastores.png)

You can then use grafana to create you're own dashboards or the following dashboards have been included:
![](images/dashboards.png)

Cloud Foundry Job specific dashboards use metrics from CF Collector to show things like DEA available memory ratios and CPU load.  Annotations are included to show "bosh deploy" events and enable correlation between changes and incidents.
![](images/DEA_stats.png)

VM dashboards provide VM level statistics from Bosh Monitor to show things like ephemeral disk or swap utilzation.
![](images/bosh_stats.png)

Enabled alerts from heka (such as DEA memory and bosh deploy's) will go to your slack channel for team notification.  You can also modify the heka configuration to send alerts to an email address if you prefer.
<img src=images/slack.png width=500 height=600 />
