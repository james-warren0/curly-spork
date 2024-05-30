# terraform {
#   required_version = ">= 0.11.0"
# }


variable "db_secret" {
  type      = string
  sensitive = true
}



resource "random_pet" "server" {
  keepers = {
    foo = "biz"
  }
}

resource "random_pet" "database" {
  keepers = {
    foo = var.db_secret
  }
}


output "db" {
  value     = var.db_secret
  sensitive = true
}


# # data "external" "env" {
# #   program = ["python", "-c", '"from os import environ; print({k:v for (k, v) in environ.items()})"']
# # }

# data "external" "env" {
#   program = ["bash", "./get-env.sh"]
# }

# module "iam_user" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-user"

#   name          = "vasya.pupkin"
#   force_destroy = true

#   # pgp_key = "keybase:test"

#   password_reset_required = false
# }
