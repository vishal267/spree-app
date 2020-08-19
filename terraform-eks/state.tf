terraform {
 backend "s3" {
# encrypt = true
 bucket = "one.debian.com-terraform4"
 region = "us-west-2"
 key = "state_file"
 }
}
