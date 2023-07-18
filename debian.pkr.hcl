packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "debian" {
  ami_name      = "my-debian-11-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "eu-central-1"

  source_ami_filter {
    filters = {
      name                = "debian-11-amd64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      architecture        = "x86_64"
    }
    most_recent = true
    owners      = ["136693071363"]
  }

  ssh_username = "admin"
  ssh_timeout  = "2m"

  ami_description = "A general purpose Debian 11 (Bullseye) build"

  tags = {
    Name = "My general purpose Debian"
  }
}

build {
  name = "first"

  sources = [
    "source.amazon-ebs.debian"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"

    extra_arguments = [
      "--flush-cache",
    ]
  }
}
