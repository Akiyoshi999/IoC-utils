# SG
# ec2

resource "aws_security_group" "app-sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "app role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_security_group_rule" "app-sg" {
  for_each          = local.app-sg
  security_group_id = aws_security_group.app-sg.id
  type              = each.value.type
  protocol          = each.value.protocol
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_blocks       = each.value.cidr_blocks
}
