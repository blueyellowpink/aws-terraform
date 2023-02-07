variable "env_name" {
  type    = string
  default = "dev"
}

variable "identity_file" {
  type    = string
  default = "~/.ssh/terraform_deployer.pub"
}

variable "availability_zone" {
  type    = string
  default = "ap-southeast-1a"
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "credentials" {
  type    = list(string)
  default = ["~/.aws/credentials"]
}

variable "profile" {
  type    = string
  default = "default"
}
