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

// vpc and internet gateway, one igw is enough for the two availability zones

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
  }
}

// subnets, creates a public and private subnet for each availability zone

module "public_subnet_1" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.availability_zone[0]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[0]
}

module "public_subnet_2" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.availability_zone[1]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[0]
}

module "private_subnet_1" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[2]
    availability_zone = var.availability_zone[0]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[1]
}

module "private_subnet_2" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[3]
    availability_zone = var.availability_zone[1]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[1]
}

// route tables, creates a route table and all needed components (3) for each subnet


module "route_table_public_1" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    gateway_id = aws_internet_gateway.main.id
    //module from where i get output .output value 
    subnet_id = module.public_subnet_1.mySubnet.id
}

module "route_table_public_2" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    gateway_id = aws_internet_gateway.main.id
    //module from where i get output .output value 
    subnet_id = module.public_subnet_2.mySubnet.id
}

// before creating the route tables for my private subnets i need a nat gateway

module "nat_av_1" {
    source = "./modules/nat"
    subnet_id = module.public_subnet_1.mySubnet.id //need to be on public subnet
    environment = var.environment
    depends_on = [aws_internet_gateway.main]
}

module "nat_av_2" {
    source = "./modules/nat"
    subnet_id = module.public_subnet_2.mySubnet.id
    environment = var.environment
    depends_on = [aws_internet_gateway.main]
}

// private route tables

module "route_table_private_1" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    nat_gateway_id = module.nat_av_1.myNat.id
    //module from where i get output .output value 
    subnet_id = module.private_subnet_1.mySubnet.id
}

module "route_table_private_2" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    nat_gateway_id = module.nat_av_2.myNat.id
    //module from where i get output .output value 
    subnet_id = module.private_subnet_2.mySubnet.id
}

// security group for application load balancer

resource "aws_security_group" "alb-sg" {
  name   = "${var.name}-alb-sg-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = var.environment
  }
}

// security group for ECS task (allows access to the app exposed port) may need another----------------------------------

resource "aws_security_group" "ecs_tasks_sg" {
  name   = "${var.name}-task-sg-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = var.container_port
    to_port          = var.container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = var.environment
  }
}

// erc repo
/*
resource "aws_ecr_repository" "ecs_app_repo" {
  name                 = "${var.name}-${var.environment}"
  image_tag_mutability = "MUTABLE" //add latest tag to the last image added to repo

  image_scanning_configuration {
    scan_on_push = false // check if the code on image is correct
  }
}

// this ecr policy is for the repo to only keep 20 images at the time once exceeded will erase older versions

resource "aws_ecr_lifecycle_policy" "ecs_app_repo_pol" {
  repository = aws_ecr_repository.ecs_app_repo.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 20 images"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
    }]
  })
}*/

// ecs cluster

module "esc_cluster" {
    source = "./modules/ecs"
    //cluster
    name = "${var.name}-cluster-${var.environment}"
    environment = var.environment
    //log group
    log_lgr_name = "${var.name}-lgr-${var.environment}"
    //task definition
    task_name = "${var.name}-task-${var.environment}"
    net_mode = var.net_mode
    ecs_type = var.ecs_type
    container_cpu = var.container_cpu
    container_memory = var.container_memory
    container_name = "${var.name}-container-${var.environment}"
    container_image = var.container_image //image uploaded to ecr, check if you can  upload an initial image when creating a ecr repo
    essential = var.essential
    container_port = var.container_port
    container_host_port = var.container_host_port
    protocol = var.protocol
    log_driver = var.log_driver
    log_group_name = "${var.name}-cluster_group-${var.environment}"
    region = var.region
    //rol for task exc
    rol_name = "${var.name}-cluster-rol-${var.environment}"
    //service
    service_name = "${var.name}-service-${var.environment}"
    service_desired_count = var.service_desired_count
    deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
    deployment_maximum_percent = var.deployment_maximum_percent
    health_check_grace_period_seconds = var.health_check_grace_period_seconds
    scheduling_strategy = var.scheduling_strategy
    aws_alb_target_group_arn = module.load_balancer.myAlbGr.arn
    private_subnets = [module.private_subnet_1.mySubnet, module.private_subnet_2.mySubnet] //passing my two private subnets
    ecs_service_security_groups = [aws_security_group.ecs_tasks_sg]
    depends_on = [module.load_balancer]
}

// load balancer

module "load_balancer" {
    source = "./modules/alb"
    // load balancer
    alb_name = "${var.name}-alb-${var.environment}"
    environment = var.environment
    internal = var.internal
    load_balancer_type = var.load_balancer_type
    alb_security_groups = [aws_security_group.alb-sg]
    public_subnets = [module.public_subnet_1.mySubnet, module.public_subnet_2.mySubnet]
    enable_deletion_protection = var.enable_deletion_protection
    // load balancer target group
    alb_tg_name = "${var.name}-tg-lb-${var.environment}"
    alb_tg_port = var.alb_tg_port
    alb_tg_protocol = var.alb_tg_protocol
    vpc_id = aws_vpc.main.id
    alb_tg_target_type = var.alb_tg_target_type
    //alb_tg_healthy_threshold = var.alb_tg_healthy_threshold //need to check
    //alb_tg_interval = var.alb_tg_interval //need to check
    alb_tg_matcher = var.alb_tg_matcher //need to check
    //alb_tg_timeout = var.alb_tg_timeout //need to check
    alb_tg_path = var.alb_tg_path
    //alb_tg_unhealthy_threshold = var.alb_tg_unhealthy_threshold //need to check
    // http listener
    http_listener_port = var.http_listener_port
    http_listener_protocol = var.http_listener_protocol
    http_listener_action_type = var.http_listener_action_type
    http_listener_redirect_port = var.http_listener_redirect_port
    http_listener_redirect_protocol = var.http_listener_redirect_protocol
    http_listener_redirect_status_code = var.http_listener_redirect_status_code
    // https listener
    https_listener_port = var.https_listener_port
    https_listener_protocol = var.https_listener_protocol
    alb_tls_cert_arn = var.alb_tls_cert_arn // this one needs some looking into
}

// autoscaling

module "autoscaling" {
    source = "./modules/autoscaling"
    // autoscaling
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
    resource_id_autoscaling = "service/${module.esc_cluster.myECS.name}/${module.esc_cluster.myService.name}"
    scalable_dimension = var.scalable_dimension
    service_namespace = var.service_namespace
    // memory policy
    memory_pol_name = "${var.name}-memory-policy-${var.environment}"
    autoscaling_policy_type = var.autoscaling_policy_type
    predefined_metric_type_memory = var.predefined_metric_type_memory
    memory_target_value = var.memory_target_value
    scale_in_cooldown = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    // cpu policy
    cpu_pol_name = "${var.name}-cpu-policy-${var.environment}"
    predefined_metric_type_cpu = var.predefined_metric_type_cpu
    cpu_target_value = var.cpu_target_value
}

//cloudflare--------------------------------------------------

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_zone" "myDomain" {
  zone= "salvadormenendez.social"
}

resource "cloudflare_record" "record" {
  zone_id = cloudflare_zone.myDomain.id
  name = var.environment
  value = module.load_balancer.myDNS //load balancer  dns
  type = "CNAME"
  proxied = false
  ttl = 1
}




