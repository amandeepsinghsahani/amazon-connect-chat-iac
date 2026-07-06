# ==========================================
# IAM Role for Lex Bot
# ==========================================
resource "aws_iam_role" "lex_bot_role" {
  name = "miratech-optum-lex-bot-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lex.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lex_basic" {
  role       = aws_iam_role.lex_bot_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
}

# ==========================================
# Lex V2 Bot (Skeleton)
# ==========================================
resource "aws_lexv2models_bot" "support_bot" {
  name        = "miratech-optum-support-bot-${var.environment}"
  description = "Optum Support Chatbot"

  role_arn = aws_iam_role.lex_bot_role.arn

  data_privacy {
    child_directed = false
  }

  idle_session_ttl_in_seconds = 300
}

resource "aws_lexv2models_bot_locale" "en_us" {
  bot_id                           = aws_lexv2models_bot.support_bot.id
  locale_id                        = "en_US"
  bot_version                      = "DRAFT"
  n_lu_intent_confidence_threshold = 0.0
}

# ==========================================
# IAM Role for Lambda
# ==========================================
resource "aws_iam_role" "lex_fulfillment_role" {
  name = "miratech-optum-lex-fulfillment-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lex_fulfillment_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ==========================================
# Lambda Function (S3-based)
# ==========================================
resource "aws_lambda_function" "lex_fulfillment" {
  function_name = "miratech-optum-lex-fulfillment-${var.environment}"
  role          = aws_iam_role.lex_fulfillment_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30
  memory_size   = 256

  s3_bucket = "miratech-optum-lambda-code"
  s3_key    = "fulfillment.zip"

  source_code_hash = var.lambda_source_code_hash != "" ? var.lambda_source_code_hash : "initialdummyhash"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

resource "aws_lambda_permission" "allow_lex" {
  statement_id  = "AllowLexInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lex_fulfillment.function_name
  principal     = "lex.amazonaws.com"
  source_arn    = "${aws_lexv2models_bot.support_bot.arn}/*"
}