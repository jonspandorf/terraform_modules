variable "security_group_rules" {
  description = "A map of security group rules."
  type        = map(object({
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
