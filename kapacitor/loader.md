kapacitor define etcd_alert_np -type stream -tick etcd_alert_np.tick -dbrp cf_np.autogen
kapacitor enable etcd_alert_np
kapacitor define slow_consumer_np -type stream -tick slow_consumer_np.tick -dbrp cf_np.autogen
kapacitor enable slow_consumer_np
kapacitor define swap_alert_np -type stream -tick swap_alert_np.tick -dbrp cf_np.autogen
kapacitor enable swap_alert_np
kapacitor define job_health_np -type stream -tick job_health_np.tick -dbrp cf_np.autogen
kapacitor enable job_health_np
kapacitor define persistent_disk_np -type stream -tick persistent_disk_np.tick -dbrp cf_np.autogen
kapacitor enable persistent_disk_np
kapacitor define cpu_wait_alert_np -type stream -tick cpu_wait_np.tick -dbrp cf_np.autogen
kapacitor enable cpu_wait_alert_np
kapacitor define bosh_event_np -type stream -tick bosh_event_np.tick -dbrp telegraf_np.autogen
kapacitor enable bosh_event_np
kapacitor define max_container_np -type stream -tick max_container_np.tick -dbrp cf_np.autogen
kapacitor enable max_container_np
