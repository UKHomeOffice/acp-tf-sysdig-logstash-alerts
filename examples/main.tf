terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
    }
  }
}

provider "sysdig" {
  sysdig_monitor_api_token = "XXX-XXX-XXX-XXXX-XXXX" // and also taken from from environment variable SYSDIG_MONITOR_API_TOKEN
  sysdig_monitor_url = "https://sysdig.example.gov.uk"
}

module logstash_alerts {
    source = "../"
    cluster_name = "acp-example"
    namespace_name = "logstash"
    statefulset_name = "logstash"
    default_warning_notification_channels = [100] // channel id to send default warning level alerts
    default_pager_notification_channels = [200] // channel id to send default pager level alerts

    alert_pod_not_ready_default_disabled = true // disables the default pod_not_ready alerts
    alert_pod_not_ready = [{
      suffix                = "warning"
      threshold             = "100"
      trigger_after_minutes = 60
      channels              = [100]
    }]
}