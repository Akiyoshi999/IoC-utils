# ec2
resource "aws_instance" "app_host" {
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnets["1a"].id
  security_groups = [aws_security_group.app-sg.id]
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-app"
    Project = var.project
    Env     = var.environment
  }
  # docker boot template
  user_data = local.ec2.docker.user_data
}