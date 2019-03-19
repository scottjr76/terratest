terraform {
  backend "s3" {
   bucket = "table3saterraform"
   key = "terra/state"
   region = "us-west-2"
   }
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias = "ca-central-1"
  region = "ca-central-1"
}

resource "aws_instance" "frontend" {
  depends_on = ["aws_instance.backend"]
  ami = "ami-08692d171e3cf02d6"
  instance_type = "t2.micro"
  key_name = "global_key"
   tags = {
     Name = "table3sa-fe"
   }
   lifecycle {
     create_before_destroy = true
   }
}
resource "aws_instance" "backend" {
  count = 1
  provider="aws.ca-central-1"
  ami = "ami-03d12de7d0e87fbf3"
  instance_type = "t2.micro"
  key_name = "global_key"
   tags = {
     Name = "table3sa-be"
   }
   timeouts {
     create = "60m"
     delete = "2h"
   }
}
