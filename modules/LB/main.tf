resource "aws_lb" "PublicALB" {
  name               = var.publicalb-name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = ["${aws_security_group.PublicALB_sg.id}"]
  subnets            = [var.pubsubnet1,var.pubsubnet2]
  

}
resource "aws_lb_target_group" "PublicalbTG" {
  name     = "PublicalbTG"
  port     = var.Port
  protocol = var.Protocol
  vpc_id   = var.VPC-ID-FOR-LB
}

resource "aws_lb_target_group_attachment" "TGaPublic" {
  target_group_arn = aws_lb_target_group.PublicalbTG.arn
  target_id        = var.pubinst1
  port             = var.Port
}

resource "aws_lb_target_group_attachment" "TGaPublic2" {
  target_group_arn = aws_lb_target_group.PublicalbTG.arn
  target_id       = var.pubinst2
  port             = var.Port
}

resource "aws_lb_listener" "PublicLBlistener" {
  load_balancer_arn = aws_lb.PublicALB.arn
  port              = var.Port
  protocol          = var.Protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.PublicalbTG.arn
  }
}

resource "aws_lb" "PrivateALB" {
  name               = var.privatealb-name
  internal           = true
  load_balancer_type = var.load_balancer_type
  security_groups    = ["${aws_security_group.privateALB_sg.id}"]
  subnets            = [var.privsubnet1,var.privsubnet2]

}

resource "aws_lb_target_group" "privatealbTG" {
  name     = "privatealbTG"
  port     = var.Port
  protocol = var.Protocol
  vpc_id   = var.VPC-ID-FOR-LB
}

resource "aws_lb_target_group_attachment" "TGaPrivate" {
  target_group_arn = aws_lb_target_group.privatealbTG.arn
  target_id        = var.privinst1
  port             = var.Port
}

resource "aws_lb_target_group_attachment" "TGaPrivate1" {
  target_group_arn = aws_lb_target_group.privatealbTG.arn
  target_id        = var.privinst2
  port             = var.Port
}


resource "aws_lb_listener" "PrivateLBlistener" {
  load_balancer_arn = aws_lb.PrivateALB.arn
  port              = var.Port
  protocol          = var.Protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.privatealbTG.arn
  }
}

resource "aws_security_group" "PublicALB_sg" {
  name        = "PublicALB_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = var.VPC-ID-FOR-LB

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "privateALB_sg" {
  name        = "privateALB_sg"
  description = "allow ssh on 22 & http on port 80 "
  vpc_id      = var.VPC-ID-FOR-LB

  ingress {
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
