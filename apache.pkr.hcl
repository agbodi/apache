packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "packer-aws-apache"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "apache-server" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"
}

build {
  name    = "packer-apache"
  sources = [
    "source.amazon-ebs.apache-server"
  ]

  provisioner "shell" {

    inline = [
      "echo Install Apache Server - START",
      "sleep 10",
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl restart apache2",
      "echo Install apache2 - SUCCESS",
    ]
  }
}

