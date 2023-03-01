provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44MXFSGRVZ"
secret_key = "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"
}
resource "aws_instance" "key2" {
ami = var.ami
instance_type = var.itype
availability_zone = var.azone
tags = {
Name = var.iname
Environment = var.ename
}
root_block_device {
volume_size = var.vsize
}
count = var.cnt
}
variable "ami" {
description = "this is for ami"
type = string
default = "ami-0caf778a172362f1c"
}
variable "itype" {
description = "this is for itype"
type = string
default = "t2.micro"
}
variable "azone" {
description = "this is for availability zone"
type = string
default = "ap-south-1a"
}
variable "iname" {
description = "this is for inatance name"
type = string
default = "CCIT-INSTANCE"
}
variable "ename" {
description = "this is for availability environment name"
type = string
default = "PROD"
}
variable "vsize" {
description = "this is for availability volume size"
type = number
default = 10
}
variable "cnt" {
description = "this is for availability number of instances"
type = number
default = 2
}
