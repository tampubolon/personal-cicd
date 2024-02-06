output "vpc_info" {
  value       = data.cloudamqp_vpc_info.vpc_info
  description = "VPC Info"
}