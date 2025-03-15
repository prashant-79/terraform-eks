resource "aws_lb" "public_alb" {
  name                       = "${var.environment}-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = data.aws_subnets.public_subnets.ids
  enable_deletion_protection = false  
  security_groups =["sg-067327d5ae993e1e8", "sg-08a4bded7d44efc36"]
  //security_groups            = [aws_security_group.alb.id, aws_security_group.alb-internal.id]
}


resource "aws_security_group" "alb" {
  name   = "external-sg-alb"
  vpc_id = data.aws_vpc.selected.id

  dynamic "ingress" {
    for_each = var.allow_ip
    iterator = cidr
    content {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = [var.allow_ip[cidr.key]]
    }
  }

  dynamic "ingress" {
    for_each = var.allow_ip
    iterator = cidr
    content {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = [var.allow_ip[cidr.key]]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb-internal" {
  name   = "internal-sg-alb"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    self        = "false"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]


  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    self      = "false"

    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"  # Use "HTTP_301" for permanent redirect or "HTTP_302" for temporary
    }
  }
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"  # Adjust as needed
  certificate_arn = data.aws_acm_certificate.acm.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }
  }
}
