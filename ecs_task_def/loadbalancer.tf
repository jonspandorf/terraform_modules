resource "aws_alb" "public_gw" {
  count              = var.is_public_deployment ? 1 : 0
  name               = var.loadbalancer_name
  load_balancer_type = "application"
  subnets            = var.use_default_vpc ? aws_default_subnet.public_subnets.*.id : var.PUBLIC_SUBNETS
  security_groups    = ["${aws_security_group.loadbalancer-securitygroup[0].id}"]
}

resource "aws_security_group" "loadbalancer-securitygroup" {
  count              = var.is_public_deployment ? 1 : 0
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.public_endpoint_ports[0]
    to_port     = var.public_endpoint_ports[1]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow-traffic-lb"
  }

}

resource "aws_lb_target_group" "service_tg" {
  count       = var.is_public_deployment ? 1 : 0
  name        = "${var.service_name}-tg"
  port        = var.public_endpoint_ports[0]
  protocol    = (var.public_endpoint_ports[0] == 80 || var.public_endpoint_ports[0] == 9080) ? "HTTP" : "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}


resource "aws_lb_listener" "listener" {
  count              = var.is_public_deployment ? 1 : 0
  load_balancer_arn = aws_alb.public_gw[0].arn
  port              = var.public_endpoint_ports[0]
  protocol          = (var.public_endpoint_ports[0] == 80 || var.public_endpoint_ports[0] == 9080) ? "HTTP" : "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.*.arn
  }
}