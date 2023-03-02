root@ip-172-31-36-105:~# vim main.tf
provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44KLYODJ7N"
secret_key = "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"
}

resource "aws_instance" "key1" {
ami = "ami-0caf778a172362f1c"
instance_type = "t2.micro"
availability_zone = "ap-south-1a"
associate_public_ip_address = var.abc
tags = {
Name = "CCIT3"
Environment = "DEV"
}
}

variable "abc" {
description = "this is for enable public ip"
type = bool
default = true
}
