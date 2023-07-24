locals {
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
    "us-east-1f",
  ]
}
# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
  count = var.use_default_vpc ? 1 : 0
}

resource "aws_default_subnet" "private_subnets" {
  count                   = (var.use_default_vpc && var.is_public_deployment == false) ? var.service_container_count : 0
  availability_zone       = element(local.availability_zones, count.index)
}

resource "aws_default_subnet" "public_subnets" {
  count                   = (var.use_default_vpc && var.is_public_deployment == true) ? var.service_container_count : 0
  availability_zone       = element(local.availability_zones, count.index)
}
