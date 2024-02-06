terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudamqp = {
      source = "cloudamqp/cloudamqp"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "terraform"
    key    = "pintu-infra/cloudamqp/vpc.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  version = "~> 3.7"
  region  = "ap-southeast-1"
}