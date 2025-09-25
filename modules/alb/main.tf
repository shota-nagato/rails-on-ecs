resource "aws_lb" "main" {
  name               = "${var.common.prefix}-${var.common.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.network.public_subnet_ids
  security_groups    = [var.network.security_group_alb_id]

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-alb"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.common.prefix}-${var.common.environment}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  # TODO: 証明書の準備が完了後HTTPSに変更する
  protocol = "HTTP"
  port     = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
