terraform {
  required_version = ">= 0.11.0"
}

data "external" "example" {
  program = ["echo", "{\"foo\": \"${timestamp()}\"}"]
}
