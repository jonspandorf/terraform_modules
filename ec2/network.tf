locals {
  availability_zones = {
    us-east-1 = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d",
      "us-east-1e",
      "us-east-1f",
    ]
  }
}

resource "aws_default_vpc" "default_vpc" {
  count = !var.requested_subnet ? 1 : 0
}

resource "aws_default_subnet" "default_subnet" {
  count             = !var.requested_subnet ? length(var.instances) : 0
  availability_zone = element(local.availability_zones[var.AWS_REGION], count.index)
}
