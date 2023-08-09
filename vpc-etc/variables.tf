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