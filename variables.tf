variable "cluster_name" {
    type = string
}

variable "namespace_name" {
    type = string
}

variable "statefulset_name" {
    type = string
}

variable "default_pager_notification_channels" {
    type = list(number)
}

variable "default_warning_notification_channels" {
    type = list(number)
}

variable "alert_pod_not_ready" {
    type = list(object({
      suffix                = string
      trigger_after_minutes = number
      channels              = list(number)
      threshold    = string
    }))
    default = []
}

variable "alert_pod_not_ready_default_disabled" {
  type = bool
  default = false
}

variable "alert_logstash_up" {
    type = list(object({
      suffix                = string
      trigger_after_minutes = number
      channels              = list(number)
      threshold    = string
    }))
    default = []
}

variable "alert_logstash_up_default_disabled" {
  type = bool
  default = false
}