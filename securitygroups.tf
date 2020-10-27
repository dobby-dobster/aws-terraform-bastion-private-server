# Creating security group for Bastion Host/Jump Box
resource "aws_security_group" "bh-sg" {

  depends_on = [
    aws_vpc.vpc,
    aws_subnet.private_subnet,
    aws_subnet.public_subnet
  ]

  description = "SSH only access into bastion/jumpbox"
  name        = "bastion-host-sg"
  vpc_id      = aws_vpc.vpc.id

  # Created an inbound rule for Bastion Host SSH
  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from Bastion Host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating security group for private server
resource "aws_security_group" "private_server-sg" {

  depends_on = [
    aws_vpc.vpc,
    aws_subnet.private_subnet,
    aws_subnet.public_subnet
  ]

  description = "SSH only access into private server from bastion"
  name        = "private-server-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Bastion Host SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bh-sg.id]
  }

  egress {
    description = "Egress from private server"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}