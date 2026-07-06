variable "environment" {
    type = string
}

variable "aws_region" {
    default = "us-east-1"
}

variable "instance_alias" {
    default = "optum-chat"
}

variable "lambda_source_code_hash" {
  description = "Base64 SHA256 of the Lambda zip file (provided by CI/CD)"
  type        = string
  default     = ""
}
