
resource "aws_instance" "this" {

  for_each = var.instances

  ami           = each.value.requested_ami
  instance_type = each.value.flavor

  tags = {
    Name = "${each.value.tag_name}"
  }

  subnet_id            = var.requested_subnet ? var.requested_subnet : aws_default_subnet.default_subnet.*.id
  key_name             = var.key_name
  security_groups      = var.security_groups
  iam_instance_profile = var.iam_profile_name
  user_data            = var.deploy_docker_and_jenkins ? file("ubuntu_docker_jenkins.sh") : ""
}

output "instance_public_ip" {
  value = aws_instance.this.*.public_ip
}

