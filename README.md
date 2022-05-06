# acp-tf-sysdig-logstash-alerts

Terraform module to create Sysdig alerts for Logstash 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | 0.5.37 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_sysdig"></a> [sysdig](#provider\_sysdig) | 0.5.37 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [sysdig_monitor_alert_metric.logstash_pipeline_events_out](https://registry.terraform.io/providers/sysdiglabs/sysdig/0.5.37/docs/resources/monitor_alert_metric) | resource |
| [sysdig_monitor_alert_metric.logstash_up](https://registry.terraform.io/providers/sysdiglabs/sysdig/0.5.37/docs/resources/monitor_alert_metric) | resource |
| [sysdig_monitor_alert_metric.pod_not_ready](https://registry.terraform.io/providers/sysdiglabs/sysdig/0.5.37/docs/resources/monitor_alert_metric) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_logstash_up"></a> [alert\_logstash\_up](#input\_alert\_logstash\_up) | List of custom logstash\_up prometheus alerts | <pre>list(object({<br>    suffix                = string<br>    trigger_after_minutes = number<br>    channels              = list(number)<br>    threshold             = string<br>  }))</pre> | `[]` | no |
| <a name="input_alert_logstash_up_default_disabled"></a> [alert\_logstash\_up\_default\_disabled](#input\_alert\_logstash\_up\_default\_disabled) | Toggle to disable default logstash\_up | `bool` | `false` | no |
| <a name="input_alert_pod_not_ready"></a> [alert\_pod\_not\_ready](#input\_alert\_pod\_not\_ready) | List of custom kubernetes.pod.status.ready alerts | <pre>list(object({<br>    suffix                = string<br>    trigger_after_minutes = number<br>    channels              = list(number)<br>    threshold             = string<br>  }))</pre> | `[]` | no |
| <a name="input_alert_pod_not_ready_default_disabled"></a> [alert\_pod\_not\_ready\_default\_disabled](#input\_alert\_pod\_not\_ready\_default\_disabled) | Toggle to disable default pod\_not\_ready alerts | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | kubernetes.cluster.name used in alert scope | `string` | n/a | yes |
| <a name="input_default_pager_notification_channels"></a> [default\_pager\_notification\_channels](#input\_default\_pager\_notification\_channels) | Warning notification channels used in default alerts | `list(number)` | n/a | yes |
| <a name="input_default_warning_notification_channels"></a> [default\_warning\_notification\_channels](#input\_default\_warning\_notification\_channels) | Pager notification channels used in default alerts | `list(number)` | n/a | yes |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | kubernetes.namespace.name used in alert scope | `string` | n/a | yes |
| <a name="input_statefulset_name"></a> [statefulset\_name](#input\_statefulset\_name) | kubernetes.statefulSet.name used in alert scope | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->