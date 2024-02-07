locals {
  instance_name = "pintu-test"
  environment   = "test"
  owner         = "team-sre"
  cloudamqp_tag = ["Terraform"]
  vpc_id        = "196329"
  region        = "amazon-web-services::ap-southeast-1"
  rmq_plan      = "lemur"
  rmq_version   = "3.10.5"

  default_tags = {
    Environment = local.environment
    Owner       = local.owner
    ManagedBy   = "terraform"
    TFProject   = "github.com/tampubolon/pintu-infra/cloudamqp/instance"
  }
}

data "aws_ssm_parameter" "api_key" {
  name = "/pintu/cloudamqp-api-key"
}

# Configure the CloudAMQP Provider
provider "cloudamqp" {
  apikey = data.aws_ssm_parameter.api_key.value
}

# Add instance to managed VPC
resource "cloudamqp_instance" "pintu_test" {
  name   = local.instance_name
  plan   = local.rmq_plan
  region = local.region
  tags   = ["terraform"]
}