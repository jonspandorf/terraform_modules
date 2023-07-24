variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "use_default_vpc" {
  type    = bool
  default = true
}

variable "vpc_id" {
    type = string
}

variable "requested_ecs" {
  type = string
}

variable "PUBLIC_SUBNETS" {
  type = list(any)
  default = []
}

variable "PRIVATE_SUBNETS" {
  type = list(any)
  default = []
}

variable "ecr_image_url" {
  type = string
}

variable "container_name" {
  type = string
}


variable "build_number" {
  type    = string
  default = "latest"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "ecs_task_port" {
  type    = number
  default = 80
}

variable "container_ram" {
  type    = number
  default = 128
}

variable "container_cpu" {
  type    = number
  default = 128
}

variable "task_ram" {
  type    = number
  default = 512
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_role_name" {
  type    = string
  default = "DeployECSTask"
}

variable "is_public_deployment" {
  type    = bool
  default = true
}

variable "service_name" {
  type    = string
  default = "MyAwesomeECSService"
}

variable "service_container_count" {
  type    = number
  default = 2
}

variable "loadbalancer_name" {
  type    = string
  default = "MySLB"
}

variable "public_endpoint_ports" {
  type    = list(number)
  default = [80, 80]
}

variable "requested_security_group_id" {
  type = string
  default = ""
}

variable "container_env" {
  type = list(object({
    name = string 
    value = string
  }))
  default = []
}