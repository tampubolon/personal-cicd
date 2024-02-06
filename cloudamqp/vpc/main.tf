locals {
  name                  = "pintu"
  environment           = "poc"
  vpc_cidr              = "10.124.0.0/24"
  owner                 = "team-sre"

  default_tags = {
    Environment = local.environment
    Owner       = local.owner
    ManagedBy   = "terraform"
    TFProject   = "github.com/tampubolon/pintu-infra/cloudamqp/vpc"
  }
}

data "aws_ssm_parameter" "api_key" {
  name = "/pintu/cloudamqp-api-key"
}

# Configure the CloudAMQP Provider
provider "cloudamqp" {
  apikey = data.aws_ssm_parameter.api_key.value
}

# CloudAMQP Managed VPC
resource "cloudamqp_vpc" "vpc" {
  name   = local.name
  region = "amazon-web-services::ap-southeast-1"
  subnet = local.vpc_cidr
  tags   = ["Terraform"]
}

# CloudAMQP - Extract vpc information
data "cloudamqp_vpc_info" "vpc_info" {
  vpc_id = cloudamqp_vpc.vpc.id
}