data "aws_kms_alias" "ebs" {
  name = "alias/ebs"
}

data "template_file" "userdata" {
  template = file("user_data.sh")
  vars = {
    domain_name = "${var.domain_name}"
    dir_domain_name = "${var.dir_domain_name}"
    dir_username = "${var.dir_username}"
    dir_password = "${var.dir_password}"
	}
}

resource "aws_launch_template" "launch_inboundproxy" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      kms_key_id = data.aws_kms_alias.ebs.target_key_arn
      volume_type = "gp2"
      volume_size = 40
      encrypted = true
      
    }
}
  
  name_prefix   = "Inboundproxy"
  image_id      = data.aws_ami.inboundproxy.id
  vpc_security_group_ids  = [aws_security_group.inboundproxy_sg.id]
  
  instance_type = var.inboundproxy_instance_type
  disable_api_termination = var.vm_disable_api_termination
  #key_name                = var.key_name
  user_data               = "${base64encode(data.template_file.userdata.rendered)}"
  tag_specifications {
      resource_type = "volume"
      tags = {
        Name = "Inbound Proxy"
        Build = var.build_tag
        Owner = "infrastructure"
      }
    }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg_inboundproxy"{
  name = "${aws_launch_template.launch_inboundproxy.name_prefix}-asg"
  vpc_zone_identifier = var.vpc_zone
  desired_capacity = 1
  max_size = 1 
  min_size = 1
  launch_template {
    id = "${aws_launch_template.launch_inboundproxy.id}"
    version = "$Latest" 
  }

  tags = [
    {
      key                 = "Name"
      value               = "Inbound Proxy"
      propagate_at_launch = true
    },
    {
      key                 = "Build"
      value               = var.build_tag
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "infrastructure"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}

