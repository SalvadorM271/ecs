terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.12"
  backend "remote" {
    organization = "personal_demos"

    workspaces { prefix = "ecs-" }
  }
  
}


provider "aws" {
    region = "us-east-2"
}













