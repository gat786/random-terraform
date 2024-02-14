# variable "lambda_function_config" {
#   description = "Configuration for the Lambda function"
#   type = object({
#     function_name = string
#     handler       = string
#     runtime       = string
#   })
# }

# variable "aws_iam_policy_for_lambda" {
#   description = "IAM policy for the Lambda function"
#   type = object({
#     name    = string
#     actions = list(string)
#   }) 
# }

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-west-2"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "custom/lambda/log-trigger-lambda"
}
