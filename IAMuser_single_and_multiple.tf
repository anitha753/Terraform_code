///*****SINGLE IAM-USER creation****////

provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44KLYODJ7N"
secret_key = "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"
}

resource "aws_iam_user" "key1" {
name = "myuser1"
}


///*****MULTIPLE IAM-USERs creation****////
provider "aws" {
region = "ap-south-1"
access_key = "AKIAQIZETP44KLYODJ7N"
secret_key = "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"
}

resource "aws_iam_user" "key2" {
count = length(var.abc)
name = var.abc[count.index]
} 
variable "abc" {
type = list(string)
default = ["user1" , "user2" , "user3"]
}
