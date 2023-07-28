data "aws_ecs_cluster" "target_ecs" {
  cluster_name = var.requested_ecs
}
resource "aws_ecs_service" "public" {
  count           = var.is_public_deployment ? 1 : 0
  name            = var.service_name
  cluster         = data.aws_ecs_cluster.target_ecs.id
  task_definition = aws_ecs_task_definition.containers.arn
  launch_type     = "FARGATE"
  desired_count   = var.service_container_count

  load_balancer {
    target_group_arn = aws_lb_target_group.service_tg[0].arn
    container_name   = aws_ecs_task_definition.containers.family
    container_port   = var.ecs_task_port
  }

  network_configuration {
    subnets          = var.use_default_vpc ? aws_default_subnet.public_subnets.*.id : var.PUBLIC_SUBNETS
    assign_public_ip = true
    security_groups  = ["${aws_security_group.allow_public_traffic[count.index].id}"]
  }

}

resource "aws_ecs_service" "private" {
  count           = var.is_public_deployment ? 0 : 1
  name            = var.service_name
  cluster         = data.aws_ecs_cluster.target_ecs.id
  task_definition = aws_ecs_task_definition.containers.arn
  launch_type     = "FARGATE"
  desired_count   = var.service_container_count
  enable_execute_command =  true

  network_configuration {
    subnets          = var.use_default_vpc ?  aws_default_subnet.private_subnets.*.id : var.PRIVATE_SUBNETS
    assign_public_ip = true
    security_groups  = ["${aws_security_group.allow_private_traffic[count.index].id}"]
  }

}


