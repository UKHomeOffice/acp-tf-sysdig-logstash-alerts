variable "cluster_name" {
  type = string
  description = "kubernetes.cluster.name used in alert scope"
}

variable "namespace_name" {
  type = string
  description = "kubernetes.namespace.name used in alert scope"
}

variable "statefulset_name" {
  type = string
  description = "kubernetes.statefulSet.name used in alert scope"
}

variable "default_pager_notification_channels" {
  type = list(number)
  description = "Warning notification channels used in default alerts"
}

variable "default_warning_notification_channels" {
  type = list(number)
  description = "Pager notification channels used in default alerts"
}

variable "alert_pod_not_ready" {
  type = list(object({
    suffix                = string
    trigger_after_minutes = number
    channels              = list(number)
    threshold             = string
  }))
  default = []
  description = "List of custom kubernetes.pod.status.ready alerts"
}

variable "alert_pod_not_ready_default_disabled" {
  type    = bool
  default = false
  description = "Toggle to disable default pod_not_ready alerts"
}

variable "alert_logstash_up" {
  type = list(object({
    suffix                = string
    trigger_after_minutes = number
    channels              = list(number)
    threshold             = string
  }))
  default = []
  description = "List of custom logstash_up prometheus alerts"
}

variable "alert_logstash_up_default_disabled" {
  type    = bool
  default = false
  description = "Toggle to disable default logstash_up"
}
