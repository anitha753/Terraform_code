.
└── modules
    ├── bucket
    │   ├── acl.tf
    │   ├── main.tf
    │   ├── public_access_block.tf
    │   ├── variable.tf
    │   └── versioning.tf
    ├── group
    │   ├── main.tf
    │   └── variable.tf
    ├── instance
    │   ├── main.tf
    │   ├── security.tf
    │   └── variable.tf
    ├── main.tf
    ├── provider.tf
    └── user
        ├── main.tf
        └── variable.tf

5 directories, 14 files

                                ///////////////// terraform code for bucket/////

/root@ip-172-31-36-105:~/modules/bucket# cat main.tf
resource "aws_s3_bucket" "b" {
bucket = var.bname
}

root@ip-172-31-36-105:~/modules/bucket# cat variable.tf
variable "bname" {
description = "this is for bucket name"
type = string
}

root@ip-172-31-36-105:~/modules/bucket# cat acl.tf
resource "aws_s3_bucket_acl" "a" {
bucket = "${aws_s3_bucket.b.id}"
acl = "public"
}

root@ip-172-31-36-105:~/modules/bucket# cat public_access_block.tf 
resource "aws_s3_bucket_public_access_block" "pab" {
bucket = aws_s3_bucket.b.id
block_public_acls = false
block_public_policy = false
ignore_public_acls = false
restrict_public_buckets = false
}
root@ip-172-31-36-105:~/modules/bucket# cat versioning.tf
resource "aws_s3_bucket_versioning" "v" {
bucket = aws_s3_bucket.b.id
versioning_configuration {
status = "Enabled"
}
}

///////////////////////////code for user//////////////
    
root@ip-172-31-36-105:~/modules/user# cat main.tf
resource "aws_iam_user" "u" {
name = var.uname
}

root@ip-172-31-36-105:~/modules/user# cat variable.tf 
variable "uname" {
description = "this is for user name"
type = string
}

///////////////////////////code for group//////////////
    
root@ip-172-31-36-105:~/modules/group# cat main.tf
resource "aws_iam_group" "g" {
name = var.gname
}

root@ip-172-31-36-105:~/modules/group# cat variable.tf 
variable "gname" {
description = "this is for group name"
type = string
}


/////////////////////////////code for instance with security group////////////
root@ip-172-31-36-105:~/modules/instance# cat main.tf
resource "aws_instance" "i" {
ami = var.myami
instance_type = var.itype
availability_zone = var.azone
key_name = var.kname
vpc_security_group_ids = [aws_security_group.demo-sg.id]
tags = {
Name = var.iname
Environment = var.ename
}
root_block_device {
volume_size = var.vsize
}
count = var.cnt
}

root@ip-172-31-36-105:~/modules/instance# cat variable.tf
variable "myami" {
description = "this is for ami"
type = string
}
variable "itype" {
description = "this is for itype"
type = string
}
variable "azone" {
description = "this is for availability zone"
type = string
}
variable "kname" {
description = "this is for key name"
type = string
}
variable "iname" {
description = "this is for inatance name"
type = string
}
variable "ename" {
description = "this is for availability environment name"
type = string
}
variable "vsize" {
description = "this is for availability volume size"
type = number
}
variable "cnt" {
description = "this is for availability number of instances"
type = number
}
root@ip-172-31-36-105:~/modules/instance# cat security.tf
resource "aws_security_group" "demo-sg"{
name = "sec-sg"
description = "it allows all traffic"
ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


/////////////////////////////code for   main.tf   and   provider.tf    //////////////
 root@ip-172-31-36-105:~/modules# cat main.tf
module "module-1" {
source = "./instance"
myami = "ami-0caf778a172362f1c"
itype = "t2.micro"
azone = "ap-south-1a"
kname = "mykey"
iname = "CCIT-PROJECT"
ename = "DEV"
vsize = 15
cnt = 1
}
module "module-2" {
source = "./user"
uname = "myuser"
}
module "module-3" {
source = "./group"
gname = "mygroup"
}
module "module-4" {
source = "./bucket"
bname = "mymodulesprojectforbucket"
}

root@ip-172-31-36-105:~/modules# cat provider.tf
provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44KJS3CLAX"
secret_key = "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"
}   
