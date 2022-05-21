packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "apache-server" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  security_group_id = "${var.security_group_id}"
  subnet_id     = "${var.subnet_id}"
  associate_public_ip_address = true
  source_ami_filter {
    filters = {
      image-id = "${var.ami_id}"
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
  source = "source.amazon-ebs.apache-server" {
    ssh_username = "ec2-user"
    }
 provisioner "ansible" {
  playbook_file = "../ansible/application.yml"
}

  }

