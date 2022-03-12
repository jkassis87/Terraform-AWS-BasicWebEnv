# ---- compute/main.tf ----

data "aws_ami" "webserver_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["AlmaLinux OS 8.4 x86_64-c076b20a-2305-4771-823f-944909847a05"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "tftest_webserver" {
  count         = var.instance_count
  ami           = data.aws_ami.webserver_ami.id
  instance_type = var.instance_type

  tags = {
    Name = "Web Server"
  }
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [var.public_sg]
}
