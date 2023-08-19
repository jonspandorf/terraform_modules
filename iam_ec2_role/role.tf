resource "aws_iam_policy" "ec2_policy" {
    name = var.policy_name 
    path = "/"
    description = "Policy to provide permissions to ec2"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = []
        }
      ]
    })
}

resource "aws_iam_role" "custom_role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy_attachment" "custom_policy_attachment" {
  count = length(var.attached_policies)

  policy_arn = var.attached_policies[count.index]
  roles      = [aws_iam_role.custom_role.name]
}

resource "aws_iam_instance_profile" "custom_instance_profile" {
  name = var.instance_profile_name
  roles = [aws_iam_role.custom_role.name]
}

output "role_name" {
  description = "The name of the created IAM role."
  value       = aws_iam_role.custom_role.name
}

output "role_arn" {
  description = "The ARN of the created IAM role."
  value       = aws_iam_role.custom_role.arn
}

output "instance_profile_name" {
  description = "The name of the created IAM instance profile."
  value       = aws_iam_instance_profile.custom_instance_profile.name
}

output "instance_profile_arn" {
  description = "The ARN of the created IAM instance profile."
  value       = aws_iam_instance_profile.custom_instance_profile.arn
}
