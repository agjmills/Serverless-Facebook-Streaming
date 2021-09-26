resource "aws_ecs_cluster" "ffmpeg-s3-facebook" {
  name = "ffmpeg-s3-facebook"
}

resource "aws_ecs_task_definition" "facebook-s3-facebook" {
  family                   = "facebook-s3-facebook"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = <<DEFINITION
[
  {
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.project_name}:latest",
    "name": "project-container",
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "${data.aws_region.current.name}",
                    "awslogs-group" : "stream-to-log-fluentd",
                    "awslogs-stream-prefix" : "${var.project_name}"
                }
            }
    }

]
DEFINITION
}
