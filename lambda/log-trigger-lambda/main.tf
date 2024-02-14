resource "aws_lambda_permission" "logging" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logging.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.default.arn}:*"
}

resource "aws_cloudwatch_log_group" "default" {
  name = "/default"
}

resource "aws_cloudwatch_log_group" "execution_logs" {
  name = var.log_group_name
}

resource "aws_cloudwatch_log_subscription_filter" "logging" {
  depends_on      = [aws_lambda_permission.logging]
  destination_arn = aws_lambda_function.logging.arn
  filter_pattern  = ""
  log_group_name  = aws_cloudwatch_log_group.default.name
  name            = "logging_default"
}

resource "aws_lambda_function" "logging" {
  function_name = "lambda_called_from_cloudwatch_logs"
  handler       = "lambda_function.lambda_handler"
  filename      = "sample.zip"
  role          = aws_iam_role.default.arn
  runtime       = "python3.7"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "logs" {
  name   = "lambda-logs"
  role   = aws_iam_role.default.name
  policy = jsonencode({
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:${var.region}:${var.account_id}:log-group:${var.log_group_name}"
      }
    ]
  })
}

resource "aws_iam_role" "default" {
  name               = "iam_for_lambda_called_from_cloudwatch_logs"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
