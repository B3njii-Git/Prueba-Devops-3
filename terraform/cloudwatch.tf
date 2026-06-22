resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "laboratorio-academy-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.main.name]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Cluster CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.main.name]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Cluster Memory Utilization"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.ecs_logs.name}' | fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 20"
          region  = "us-east-1"
          title   = "Application Errors (Logs)"
          view    = "table"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 12
        width  = 24
        height = 4
        properties = {
          markdown = "### CI/CD Metrics\n- **Deployment Time**: Available in GitHub Actions.\n- **Test Coverage**: Available in GitHub Actions UI / Audit Scripts.\n- Pipeline enforces compliance rules automatically."
        }
      }
    ]
  })
}
