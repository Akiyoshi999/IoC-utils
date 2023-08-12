variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "public" {
  type = string
}

variable "private" {
  type = string
}

variable "AZ" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-0e25eba2025eea319"
}

# Network
locals {
  subnets = {
    public = {
      "1a" = {
        cidr   = "192.168.1.0/24"
        az     = "ap-northeast-1a"
        public = true
      },
      "1c" = {
        cidr   = "192.168.2.0/24"
        az     = "ap-northeast-1c"
        public = true
      },
    }
    private = {
      "1a" = {
        cidr   = "192.168.3.0/24"
        az     = "ap-northeast-1a"
        public = false
      },
      "1c" = {
        cidr   = "192.168.4.0/24"
        az     = "ap-northeast-1c"
        public = false
      },
    }
  }
}

# SG
locals {
  app-sg = {
    "ssh" = {
      type        = "ingress"
      protocol    = "tcp"
      port        = 22
      cidr_blocks = ["0.0.0.0/0"]
    }
    "all-egress" = {
      type        = "egress"
      protocol    = "all"
      port        = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
    # "http" = {
    #   type        = "egress"
    #   protocol    = "tcp"
    #   port        = 80
    #   cidr_blocks = ["0.0.0.0/0"]
    # }
    # "https" = {
    #   type        = "egress"
    #   protocol    = "tcp"
    #   port        = 443
    #   cidr_blocks = ["0.0.0.0/0"]
    # }
  }
}

# ec2
locals {
  ec2 = {

    docker = {
      user_data = <<EOF
    #!/bin/bash -x
    yum update -y
    amazon-linux-extras install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    EOF
    }
  }
}