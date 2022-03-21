# ---- compute/main.tf ----

data "aws_ami" "webserver_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "tftest_webserver" {
  count         = var.instance_count
  ami           = data.aws_ami.webserver_ami.id
  instance_type = var.instance_type

  tags = {
    Name = "Web Server"
  }
  subnet_id              = var.public_subnet[count.index]
  vpc_security_group_ids = [var.public_sg]

  key_name = var.key_name
}
