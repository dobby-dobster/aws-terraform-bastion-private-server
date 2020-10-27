#Get Linux AMI ID using SSM Parameter endpoint
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "ssh-key" {
  provider   = aws
  key_name   = "automation"
  public_key = file("/var/tmp/aws_id_rsa.pub")
}

resource "aws_instance" "bh" {

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.ssh-key.key_name
  vpc_security_group_ids = [aws_security_group.bh-sg.id]
  tags = {
    Name      = "bastion"
    CreatedBy = "terraform"
  }
}

resource "aws_instance" "private_server" {

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = aws_key_pair.ssh-key.key_name
  vpc_security_group_ids = [aws_security_group.private_server-sg.id]
  tags = {
    Name      = "private_server"
    CreatedBy = "terraform"
  }
}
