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


//cloudwatch alarms-----------------------------------

resource "aws_sns_topic" "xxxx_cloudwatch_notifications" {
  name = "xxxx_cloudwatch_notifications"
}

resource "aws_sns_topic_subscription" "xxxx_cloudwatch_notifications" {
    topic_arn = "${aws_sns_topic.xxxx_cloudwatch_notifications.arn}"
    protocol  = "email"
    endpoint  = "caravana271@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_policy_alarm" {

  alarm_name          = "high-cpu-ecs-service"
  alarm_description   = "High CPUPolicy Landing Page for ecs service"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 1

  dimensions = {
    "ServiceName" = module.esc_cluster.myService.name
    "ClusterName" = module.esc_cluster.myECS.id
  }
}










