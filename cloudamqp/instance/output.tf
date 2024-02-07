output "instance_id" {
  value       = cloudamqp_instance.pintu_test.id
  description = "RabbitMQ Instance ID"
}

output "instance_host" {
  value       = cloudamqp_instance.pintu_test.host
  description = "RabbitMQ Instance Host"
}