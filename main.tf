terraform {
  required_version = ">= 0.11.0"
}

resource "random_pet" "server" {
  keepers = {
    foo = "biz"
  }
}

# data "external" "env" {
#   program = ["python", "-c", '"from os import environ; print({k:v for (k, v) in environ.items()})"']
# }

data "external" "env" {
  program = ["bash", "./get-env.sh"]
}