resource "aws_cloudwatch_log_group" "b_log_app" {
  name              = "/ecs/b_log_app" 
}

resource "aws_cloudwatch_log_stream" "b_log_app_log_stream" {
  name           = "b-log-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.b_log_app.name
}

# vpc

# resource "aws_vpc" "b_log_app_vpc" {
#   cidr_block = "172.17.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support = true

#   tags = {
#     Name        = var.vpc_name
#   }
  
# }

# resource "aws_subnet" "private_subnet" {
#   count = length(var.availability_zones)
#   cidr_block        = cidrsubnet(aws_vpc.b_log_app_vpc.cidr_block, 8, count.index)
#   availability_zone = var.availability_zones[count.index]
#   vpc_id            = aws_vpc.b_log_app_vpc.id
# }   

# resource "aws_subnet" "public_subnet" {
#   count = length(var.availability_zones)
#   cidr_block        = cidrsubnet(aws_vpc.b_log_app_vpc.cidr_block, 8, length(var.availability_zones) + count.index)
#   availability_zone = var.availability_zones[count.index]
#   vpc_id            = aws_vpc.b_log_app_vpc.id
# }

# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.b_log_app_vpc.id
# }

# resource "aws_route" "internet_route" {
#   route_table_id         = aws_vpc.b_log_app_vpc.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.internet_gateway.id
# }

# resource "aws_eip" "nat_ips" {
#   count      = length(var.availability_zones)
#   depends_on = [aws_internet_gateway.internet_gateway]
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   count         = length(var.availability_zones)
#   subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
#   allocation_id = element(aws_eip.nat_ips.*.id, count.index)
# }

# resource "aws_route_table" "private_route_table" {
#   count  = length(var.availability_zones)
#   vpc_id = aws_vpc.b_log_app_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
#   }
# }

# resource "aws_route_table_association" "private_association" {
#   count          = length(var.availability_zones)
#   subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
#   route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
# }

# # security.tf

resource "aws_security_group" "lb_security_group" {
  name        = "b-log-app-load-balancer-security-group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "b_log_app_security_group" {
  name        = "b-log-app-security-group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = "80"
    to_port         = "80"
    security_groups = [aws_security_group.lb_security_group.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_services_connectivity" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.b_log_app_security_group.id
  security_group_id        = aws_security_group.b_log_app_security_group.id
}

resource "aws_alb" "b_log_app_alb" {
  name            = var.alb_name
  subnets         = var.public_subnets
  security_groups = [aws_security_group.lb_security_group.id]

}

resource "aws_lb_target_group" "b_log_app_lb_target_group" {
  name        = var.tg_name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "2"
    interval           = "30"
    protocol           = "HTTP"
    matcher            = "200"
    timeout            = "5"
    path              = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = var.tg_name
  }
}

resource "aws_lb_listener" "b_log_app_lb_listener" {
  load_balancer_arn = aws_alb.b_log_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.b_log_app_lb_target_group.arn
  }
}

# # File: iam.tf

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = var.ecs_task_execution_role_name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

### ECS


### Task Defenition ###

resource "aws_ecs_task_definition" "b_log_task_defenition" {
    family                   = var.task_def_family_name
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 512
    memory                   = 1024
    execution_role_arn       = var.ecs_task_execution_role_arn

    container_definitions = jsonencode([{
        name  = var.container_name
        image = var.container_image
        essential = true
        portMappings = [{
            containerPort = var.container_port
            protocol      = "tcp"
        }]
        environment = [
        {
            name = "PORT",
            value = "80"
        }
        ],
        logConfiguration = {
            logDriver = "awslogs"
            options = {
                awslogs-group         = aws_cloudwatch_log_group.b_log_app.name
                awslogs-region        = var.aws_region
                awslogs-stream-prefix = "ecs"

            }
        }
    }])

    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
  

    tags = {
        Name        = "${var.app_name}-task"
    }
}

### Service ###

resource "aws_ecs_service" "b_log_app_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.b_log_app_cluster.id
  task_definition = aws_ecs_task_definition.b_log_task_defenition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.b_log_app_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.b_log_app_lb_target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.b_log_app_lb_listener]

  tags = {
    Name        = var.service_name
  }
}



