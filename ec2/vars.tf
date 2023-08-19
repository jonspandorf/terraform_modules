variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "instances" {
  type = map(object({
    requested_ami = string
    flavor        = string
    tag_name      = string
  }))
}

variable "requested_subnet" {
  type = string
}

variable "key_name" {
  type = string
}

variable "iam_profile_name" {
  type = string 
}

variable "security_groups" {
  type = list(string)
}

variable "deploy_docker_and_jenkins" {
  type = bool 
  default = true
}