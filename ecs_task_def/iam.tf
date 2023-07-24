data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_exec_policy" {

  name = "ecs_exec_policy"
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssmmessages:CreateControlChannel",
                    "ssmmessages:CreateDataChannel",
                    "ssmmessages:OpenControlChannel",
                    "ssmmessages:OpenDataChannel"
                    ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "task_execution_role" {
  name               = var.task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole", aws_iam_policy.ecs_exec_policy.arn]
}


resource "aws_iam_role_policy_attachment" "ecs-execution-role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}