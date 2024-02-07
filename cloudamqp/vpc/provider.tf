terraform {
  required_version = "= 1.7.2"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.35.0"
    }
    cloudamqp = {
      source = "cloudamqp/cloudamqp"
      version = "~> 1.29.3"
    }
  }

  backend "s3" {
    bucket         = "terraform-martinus"
    key            = "pintu-infra/cloudamqp/vpc.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
    profile        = "martinus"
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "martinus"
}