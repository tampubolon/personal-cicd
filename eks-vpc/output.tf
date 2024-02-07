# Output VPC ID
output "vpc_id" {
  value       = aws_vpc.eks_vpc
  description = "VPC Info"
}