provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web_server" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name      = "Automation_O1"

  tags {
    Name = "my_server"
  }

  security_groups = ["allow-all-sg"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

# resource "aws_security_group" "example" {
#   name = "allow-all-sg"

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
#     # allow SSH requests from trusted servers, such as a bastion host or VPN server.
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "local_file" "foo" {
  content  = "Public IP : ${aws_instance.web_server.public_ip} , Instance Id : ${aws_instance.web_server.id}, DNS :${aws_instance.web_server.public_dns}"
  filename = "/home/rle0503/output.txt"
}
