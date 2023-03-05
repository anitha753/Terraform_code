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
    ├── user
    │   ├── main.tf
    │   └── variable.tf
    └── vpc
        ├── igw.tf
        ├── main.tf
        ├── route_table.tf
        ├── subnet.tf
        └── variable.tf
        

root@ip-172-31-36-105:~/modules/bucket# cat main.tf
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
acl = "public-read"
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
vpc_id = aws_vpc.vp.id
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
module "module-3" {
source = "./vpc"
vname = "my-vpc1"
}


root@ip-172-31-36-105:~/modules# cat provider.tf
provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44KJS3CLAX"
secret_key = "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"
}  
//////////////////////////////////////////////VPC////////////////////////////////
root@ip-172-31-50-167:~# cd modules/vpc
root@ip-172-31-50-167:~/modules/vpc# ll
total 28
drwxr-xr-x 2 root root 4096 Mar  5 20:09 ./
drwxr-xr-x 6 root root 4096 Mar  5 20:21 ../
-rw-r--r-- 1 root root   91 Mar  5 20:06 igw.tf
-rw-r--r-- 1 root root  142 Mar  5 20:02 main.tf
-rw-r--r-- 1 root root  140 Mar  5 20:09 route_table.tf
-rw-r--r-- 1 root root  116 Mar  5 19:59 subnet.tf
-rw-r--r-- 1 root root   72 Mar  5 20:02 variable.tf
root@ip-172-31-50-167:~/modules/vpc# cat igw.tf
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.vp.id
tags = {
Name = "igw-1"
}
}
root@ip-172-31-50-167:~/modules/vpc# cat route_table.tf
resource "aws_route_table" "myrt" {
vpc_id = aws_vpc.vp.id
route {
cidr_block = ["0.0.0.0/0"]
gateway_id = "aws_internet_gateway.igw.id
}
}
root@ip-172-31-50-167:~/modules/vpc# cat subnet.tf
resource "aws_subnet" "mysubnet" {
vpc_id = aws_vpc.vp.id
cidr_block = ["10.0.1.0/24"]
tags = {
Name = "subnet-1"
}
}
root@ip-172-31-50-167:~/modules/vpc# cat main.tf
resource "aws_vpc" "vp" {
cidr_block = ["10.0.0.0/16"]
instance_tenancy = "default"
enable_dns_hostnames = "true"
tags = {
Name = var.vname
}
}
root@ip-172-31-50-167:~/modules/vpc# cat variable.tf
variable "vname" {
description = "this is for vpc name"
type = string
}
