
resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.project_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_security_group"
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for project instances(behind alb)"
  vpc_id      = aws_vpc.project_vpc.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_sg"
  }
}

resource "aws_launch_template" "project-lt" {
  name                   = "project-lt"
  instance_type          = "t2.micro"
  image_id               = "ami-0c7217cdde317cfec"
  user_data              = filebase64("/home/ec2-user/projectTerraform/userdata.sh")
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "project-lt"
  }
}

resource "aws_autoscaling_group" "project-asg" {
  desired_capacity = 3
  max_size         = 10
  min_size         = 1
  launch_template {
    id = aws_launch_template.project-lt.id

  }
  vpc_zone_identifier       = aws_subnet.private_subnet[*].id # Specify your subnet IDs (in different AZs)
  health_check_type         = "EC2"
  health_check_grace_period = 300 # 300 seconds (5 minutes) is a common value, adjust as needed
  depends_on                = [aws_alb.project-alb]

  tag {
    key                 = "Name"
    value               = "project-instance"
    propagate_at_launch = true
  }
}

resource "aws_alb" "project-alb" {
  name                       = "project-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false # Set to true if you want to enable deletion protection
  subnets                    = aws_subnet.private_subnet[*].id
}


resource "aws_alb_target_group" "project" {
  name        = "project-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.project_vpc.id
}
resource "aws_autoscaling_attachment" "to-alb" {
  depends_on             = [aws_alb.project-alb, aws_alb_target_group.project]
  autoscaling_group_name = aws_autoscaling_group.project-asg.name
  lb_target_group_arn    = aws_alb_target_group.project.arn
} 

resource "aws_lb_listener" "project" {
  load_balancer_arn = aws_alb.project-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.project.arn
  }

}