variable "ami_prefix" {
  type    = string
  default = "packer-aws-apache"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0022f774911c1d690"
}

variable "subnet_id" {
  type    = string
  default = "subnet-05879b88350bb719e"
}

variable "security_group_id" {
  type    = string
  default = "sg-038456fc9b60b39c2"
}
