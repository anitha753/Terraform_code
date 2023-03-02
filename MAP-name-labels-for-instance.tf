provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44KJS3CLAX"
secret_key = "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"
}
resource "aws_instance" "key" {
ami="ami-0caf778a172362f1c"
instance_type = "t2.micro"
tags = {
Name = var.abc
}
}
variable "abc" {
type = map(string)
default = {
Project = "SWIGGY"
Environment = "DEV"
Name = "CCIT"
}
}
  
