# There may will be some requirment to update this as per the sought infomation/decision made i.e PA IPs

resource "aws_security_group" "inboundproxy_sg" {
  name   = "Traefik Inbound Proxy"
  description = "Allow acceses as per the design documentation"
  vpc_id = var.vpc_id



  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.trusted_ip_poise
  }

# PA Ips are not configured as still waiting furhter information/decission is pendig 
#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = var.trusted_PA_addresses
#  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.trusted_ip_bae
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_ip_tooling
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Inboundproxy SG"
    Build = var.build_tag
    Owner = "Infrastructure"
  }

  lifecycle {
    create_before_destroy = true
  }
}
