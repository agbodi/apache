

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type    = string
  default = "ami-0022f774911c1d690"
}

variable "public_subnet_id" {
  type    = string
  default = "subnet-05879b88350bb719e"
}

locals {
  release_id = formatdate("YYYYMMDD", timestamp())
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "firstrun" {
  ami_name                              = join("-", ["jango-base", local.release_id])
  instance_type                         = "t2.micro"
  iam_instance_profile                  = "FOR_FUSION_Console_Admins"
  region                                = var.region
  subnet_id                             = var.public_subnet_id
  associate_public_ip_address           = true
  ssh_keypair_name                      = "apache"
  security_group_filter {
    filters = {
      "tag:Class": "Dev-sec-group"
    }
  }


  #temporary_security_group_source_cidrs = ["10.8.2.0/26","10.8.2.64/26"]

source_ami_filter {
    filters = {
      image-id = "${var.ami_id}"
      #name                = "al2022-ami-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }


  ssh_username = "ec2-user"
  tags = {
    Name        = join("-", ["jango-base", local.release_id])
    Environment = "global"
    Group       = "DevOps"
    Purpose     = "Jango Base Image"
    Release_Id  = local.release_id
  }
  snapshot_tags = {
    Name        = join("-", ["jango-base", local.release_id])
    Environment = "global"
    Group       = "DevOps"
    Purpose     = "Jango Base Image"
    Release_Id  = local.release_id
  }
  encrypt_boot          = true
  force_deregister      = false
  force_delete_snapshot = false
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.firstrun"]

  provisioner "shell" {
    execute_command   = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script            = "./setup.sh"
    expect_disconnect = true
  }

}



