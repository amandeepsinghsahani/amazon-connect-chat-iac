variable "environment" {
  type = string
}

variable "lambda_source_code_hash" {
  description = "Base64 SHA256 hash of fulfillment.zip (provided by CI/CD)"
  type        = string
  default     = ""
}