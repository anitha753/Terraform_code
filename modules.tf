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

                                /////////////////terraform code/////

/root@ip-172-31-36-105:~/modules/bucket# cat main.tf
resource "aws_s3_bucket" "b" {
name = var.bname
}

root@ip-172-31-36-105:~/modules/bucket# cat variable.tf
variable "bname" {
description = "this is for bucket name"
type = "string"
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
  
