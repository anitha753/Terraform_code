provider "aws" {
region = "us-east-1"
access_key = "AKIAQIZETP44MXFSGRVZ"
secret_key = "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"
}
provider "aws" {
region = "ap-south-1"
alias = "mumbai"
access_key = "AKIAQIZETP44MXFSGRVZ"
secret_key = "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"
}

resource "aws_instance" "key1" {
ami = "ami-006dcf34c09e50022"
instance_type = "t2.micro"
availability_zone = "us-east-1a"
tags = {
Name = "CCIT1"
Environment = "DEV"
}
root_block_device {
volume_size = 10
}
}

resource "aws_instance" "key2" {
ami = "ami-0caf778a172362f1c"
instance_type = "t2.micro"
availability_zone = "ap-south-1a"
tags = {
Name = "CCIT2"
Environment = "TEST"
}
provider = "aws.mumbai"
root_block_device {
volume_size = 15
}
}
