resource "aws_security_group" "requested_sg" {
  for_each = var.security_group_rules

  name_prefix = each.key
  description = "Custom security group - ${each.key}"

  // Ingress rules
  dynamic "ingress" {
    for_each = each.value.ingress_rules

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = {
    Name = each.key
  }
}

output "security_group_ids" {
  description = "The IDs of the created security groups."
  value       = aws_security_group.custom_sg[*].id
}
