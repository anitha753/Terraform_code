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
type = "string"
}

///////////////////////////code for group//////////////
    
root@ip-172-31-36-105:~/modules/group# cat main.tf
resource "aws_iam_group" "g" {
name = var.gname
}

root@ip-172-31-36-105:~/modules/group# cat variable.tf 
variable "gname" {
description = "this is for group name"
type = "string"
}
