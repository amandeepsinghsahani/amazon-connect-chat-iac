terraform {
  required_version = ">= 1.5"
}

module "connect" {
  source = "./modules/connect"

  environment    = var.environment
  instance_alias = var.instance_alias
}

module "lex" {
  source = "./modules/lex"

  environment = var.environment
}