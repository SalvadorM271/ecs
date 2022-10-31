// creates cluster
resource "aws_ecs_cluster" "main_ecs_cluster" {
  name = var.name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Environment = var.environment
  }
}

//creates log group
resource "aws_cloudwatch_log_group" "main_lgr" {
  name = var.log_lgr_name

  tags = {
    Environment = var.environment
  }
}

// creates task definition
resource "aws_ecs_task_definition" "main" {
  family                   = var.task_name
  network_mode             = var.net_mode
  requires_compatibilities = [var.ecs_type]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name        = var.container_name
    image       = var.container_image
    essential   = var.essential
    environment = [{"name": "ENVIRONMENT", "value": "${var.environment}"}] //this envs will be pass to the container to select deploy enviroment
    portMappings = [{
      protocol      = var.protocol
      containerPort = tonumber(var.container_port)
      hostPort      = tonumber(var.container_host_port)
    }]
    logConfiguration = {
      logDriver = var.log_driver
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main_lgr.name
        awslogs-stream-prefix = "ecs"
        //awslogs-create-group = "true" // creates new log group with awslogs-group
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

// creates rol for task definition

resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.rol_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

//attach policy needed for containers to work

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

//service

resource "aws_ecs_service" "main" {
  name                               = var.service_name
  cluster                            = aws_ecs_cluster.main_ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.service_desired_count // how many container i need deploy in my case one for each zone (2)
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent // i need at least half of the container to work since im deploying in to av zones
  deployment_maximum_percent         = var.deployment_maximum_percent // if there is to much traffic i want a max of 4 
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds // how much time bf action is taken
  launch_type                        = var.ecs_type // what am i lauching ec2 or fargate
  scheduling_strategy                = var.scheduling_strategy

  network_configuration {
    security_groups  = var.ecs_service_security_groups.*.id // loop array and gets ids
    subnets          = var.private_subnets.*.id // there is more than one subnet so wildcard is use to take id for every subnet
    assign_public_ip = false //leaving this one on false can cause problems with image
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # task difinition must be ignore otherwise terraform may overwrite our app deployments since they will be do outside of terraform
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}