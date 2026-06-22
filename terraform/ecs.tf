data "aws_caller_identity" "current" {}

# Usa el rol preexistente de AWS Academy Learner Lab
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_ecs_cluster" "main" {
  name = "laboratorio-academy-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# --- CloudWatch Logs ---
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/laboratorio-academy"
  retention_in_days = 7
}

# --- Task Definition Única (All-in-one para AWS Academy) ---
resource "aws_ecs_task_definition" "app" {
  family                   = "academy-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # 1 vCPU para soportar DB + 2 Spring Boot + React
  memory                   = "3072" # 3 GB RAM
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name      = "mysql-db"
      image     = "mysql:8.0"
      essential = true
      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        }
      ]
      environment = [
        { name = "MYSQL_ROOT_PASSWORD", value = "rootpassword" },
        { name = "MYSQL_DATABASE", value = "proyecto_db" },
        { name = "MYSQL_USER", value = "admin" },
        { name = "MYSQL_PASSWORD", value = "adminpassword" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "mysql"
        }
      }
    },
    {
      name      = "app-backend-ventas"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/back-ventas:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8081
          hostPort      = 8081
        }
      ]
      environment = [
        { name = "SERVER_PORT", value = "8081" }, # Cambiamos el puerto para que no choque
        { name = "DB_ENDPOINT", value = "localhost" },
        { name = "DB_PORT", value = "3306" },
        { name = "DB_NAME", value = "proyecto_db" },
        { name = "DB_USERNAME", value = "admin" },
        { name = "DB_PASSWORD", value = "adminpassword" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ventas"
        }
      }
    },
    {
      name      = "app-backend-despachos"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/back-despachos:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8082
          hostPort      = 8082
        }
      ]
      environment = [
        { name = "SERVER_PORT", value = "8082" }, # Cambiamos el puerto para que no choque
        { name = "DB_ENDPOINT", value = "localhost" },
        { name = "DB_PORT", value = "3306" },
        { name = "DB_NAME", value = "proyecto_db" },
        { name = "DB_USERNAME", value = "admin" },
        { name = "DB_PASSWORD", value = "adminpassword" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "despachos"
        }
      }
    },
    {
      name      = "front_despacho"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/front-despachos:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])
}

# --- Service ---
resource "aws_ecs_service" "app_service" {
  name            = "academy-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
