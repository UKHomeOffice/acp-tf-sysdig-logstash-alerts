
locals {
  default_alerts = {
    pod_not_ready = [
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

    logstash_up = [
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

    logstash_pipeline_events_out = [
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

  alerts = {
    pod_not_ready                = var.alert_pod_not_ready_default_disabled ? var.alert_pod_not_ready : local.default_alerts.pod_not_ready
    logstash_up                  = var.alert_logstash_up_default_disabled ? var.alert_logstash_up : local.default_alerts.logstash_up
    logstash_pipeline_events_out = var.alert_logstash_pipeline_events_default_disabled ? var.alerts_logstash_pipeline_events_out : local.default_alerts.logstash_pipeline_events_out
  }
}


resource "sysdig_monitor_alert_metric" "pod_not_ready" {
  for_each = {
    for index, alert in local.alerts.pod_not_ready :
    alert.suffix => alert if length(alert.channels) > 0
  }
  name        = "[Logstash] ${var.cluster_name}-${var.statefulset_name}-${each.value.suffix}-pod-not-ready"
  description = "A Logstash pod is not in a ready state for ${each.value.trigger_after_minutes} minutes in cluster: ${var.cluster_name}, statefulset name: ${var.statefulset_name}"
  severity    = 3

  metric                = "avg(avg(kubernetes.pod.status.ready)) < ${each.value.threshold}"
  trigger_after_minutes = each.value.trigger_after_minutes
  scope                 = "kubernetes.cluster.name = '${var.cluster_name}' and kubernetes.namespace.name = '${var.namespace_name}' and kubernetes.statefulSet.name = '${var.statefulset_name}'"
  multiple_alerts_by    = ["kubernetes.pod.name"]

  notification_channels = each.value.channels
}

resource "sysdig_monitor_alert_metric" "logstash_up" {
  for_each = {
    for index, alert in local.alerts.logstash_up :
    alert.suffix => alert if length(alert.channels) > 0
  }
  name        = "[Logstash] ${var.cluster_name}-${var.statefulset_name}-${each.value.suffix}-logstash-up"
  description = "A Logstash container is reporting it is not up for ${each.value.trigger_after_minutes} minutes in cluster: ${var.cluster_name}, statefulset name: ${var.statefulset_name}"
  severity    = 3

  metric                = "avg(avg(logstash_up)) < ${each.value.threshold}"
  trigger_after_minutes = each.value.trigger_after_minutes
  scope                 = "kubernetes.cluster.name = '${var.cluster_name}' and kubernetes.namespace.name = '${var.namespace_name}' and kubernetes.statefulSet.name = '${var.statefulset_name}'"
  multiple_alerts_by    = ["kubernetes.pod.name"]

  notification_channels = each.value.channels
}

resource "sysdig_monitor_alert_metric" "logstash_pipeline_events_out" {
  for_each = {
    for index, alert in local.alerts.logstash_pipeline_events_out :
    alert.suffix => alert if length(alert.channels) > 0
  }
  name        = "[Logstash] ${var.cluster_name}-${var.statefulset_name}-${each.value.suffix}-logstash_pipeline_events_out"
  description = "The Logstash pipeline events output has been lower than the threshold for ${each.value.trigger_after_minutes} minutes in cluster: ${var.cluster_name}, statefulset name: ${var.statefulset_name}"
  severity    = 3

  //There is a issue in Sysdig where the formula structure GroupAggegration(TimeAggregation(metric)) isn't valid for alerts. instead of formula: sum(rateOfChange(logstash_pipeline_events_out)) it is rateOfChange(sum(avg(logstash_pipeline_events_out)))
  metric                = "rateOfChange(sum(avg(logstash_pipeline_events_out))) >= 0 AND rateOfChange(sum(avg(logstash_pipeline_events_out))) < ${each.value.threshold}"
  trigger_after_minutes = 1
  scope                 = "kubernetes.cluster.name = '${var.cluster_name}' and kubernetes.namespace.name = '${var.namespace_name}' and kubernetes.statefulSet.name = '${var.statefulset_name}'"

  notification_channels = each.value.channels
}
