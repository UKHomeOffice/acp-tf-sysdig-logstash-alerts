
locals {
  alerts_pod_not_ready = var.alert_pod_not_ready_default_disabled ? var.alert_pod_not_ready : [
    {
      suffix                = "pager"
      threshold             = "1"
      trigger_after_minutes = 60
      channels              = var.default_pager_notification_channels
    },
    {
      suffix                = "warning"
      threshold             = "1"
      trigger_after_minutes = 15
      channels              = var.default_warning_notification_channels
    }
  ]

  alerts_logstash_up = var.alert_logstash_up_default_disabled ? var.alert_logstash_up : [
    {
      suffix                = "pager"
      threshold             = "1"
      trigger_after_minutes = 60
      channels              = var.default_pager_notification_channels
    },
    {
      suffix                = "warning"
      threshold             = "1"
      trigger_after_minutes = 15
      channels              = var.default_warning_notification_channels
    }
  ]
}


resource "sysdig_monitor_alert_metric" "pod_not_ready" {
  for_each = {
    for index, alert in local.alerts_pod_not_ready :
    alert.suffix => alert
  }
  name        = "[Logstash] ${var.cluster_name}-${var.statefulset_name}-${each.value.suffix}-pod-not-ready"
  description = "test"

  metric                = "avg(avg(kubernetes.pod.status.ready)) < ${each.value.threshold}"
  trigger_after_minutes = each.value.trigger_after_minutes

  scope = "kubernetes.cluster.name = '${var.cluster_name}' and kubernetes.namespace.name = '${var.namespace_name}' and kubernetes.statefulSet.name = '${var.statefulset_name}'"

  multiple_alerts_by = ["kubernetes.pod.name"]

  notification_channels = each.value.channels
}

resource "sysdig_monitor_alert_metric" "logstash_up" {
  for_each = {
    for index, alert in local.alerts_logstash_up :
    alert.suffix => alert
  }
  name        = "[Logstash] ${var.cluster_name}-${var.statefulset_name}-${each.value.suffix}-logstash-up"
  description = "test"

  metric                = "avg(avg(logstash_up)) < ${each.value.threshold}"
  trigger_after_minutes = each.value.trigger_after_minutes

  scope = "kubernetes.cluster.name = '${var.cluster_name}' and kubernetes.namespace.name = '${var.namespace_name}' and kubernetes.statefulSet.name = '${var.statefulset_name}'"

  multiple_alerts_by = ["kubernetes.pod.name"]

  notification_channels = each.value.channels
}

resource "sysdig_monitor_alert_metric" "logstash_pipeline_events_out" {
    name = "[Logstash] ${var.cluster_name}-${var.statefulset_name}-logstash_pipeline_events_out"
    description = "test"
    severity = 6

    #metric = "sum(rateOfChange(logstash_pipeline_events_out)) < 5"
    metric = "rateOfChange(sum(avg(logstash_pipeline_events_out))) > 1"
    trigger_after_minutes = 1

    scope = "kubernetes.cluster.name = '${var.cluster_name}' and kubernetes.namespace.name = '${var.namespace_name}' and kubernetes.statefulSet.name = '${var.statefulset_name}'"

    notification_channels = [306]
}
