variable "environment" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "github_token" {
  type = string
}

variable "github_repo" {
  type    = string
  default = "devops-academy-capstone"
}

variable "github_user" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "project_name" {
  type    = string
  default = "todo"
}

variable "aws_ec2_username" {
  type    = string
  default = "ubuntu"
}

variable "aws_tags" {
  type = object({
    app = string
  })
  default = {
    app = "todo"
  }
}

