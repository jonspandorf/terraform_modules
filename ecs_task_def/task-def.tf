
data "template_file" "define-task" {
  template = file("${path.module}/templates/task_def.json.tpl")
  vars = {
    REPOSITORY_URL = "${var.ecr_image_url}"
    CONTAINER_NAME = "${var.container_name}"
    BUILD_NUMBER   = "${var.build_number}"
    CONTAINER_PORT = "${var.container_port}"
    ECS_PORT       = "${var.ecs_task_port}"
    CONTAINER_RAM  = "${var.container_ram}"
    CONTAINER_CPU  = "${var.container_cpu}"
  }
}


resource "aws_ecs_task_definition" "containers" {
  family                   = var.container_name
  container_definitions    = data.template_file.define-task.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.task_ram
  cpu                      = var.task_cpu
  execution_role_arn       = aws_iam_role.task_execution_role.arn
}

