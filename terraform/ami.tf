data "aws_ami" "inboundproxy" {
  most_recent = true
  owners = ["202696833239"]
  filter {
    name   = "name"
    values = ["InboundProxy-Amazon-Linux2-AMI-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
} 

