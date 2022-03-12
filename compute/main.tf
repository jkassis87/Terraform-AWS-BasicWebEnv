# ---- compute/main.tf ----

data "aws_ami" "webserver_ami" {
    most_recent = true
    owners = ["679593333241"]

    filter {
        name = "name"
        values = ["AlmaLinuxOS8.4x86_64"]
    }
} 

resource "aws_instance" "tftest_webserver" {
  ami           = data.aws_ami.webserver_ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "Web Server"
  }
}

vpc_security_group_ids = aws_security_group.tftest
subnet_id              = var.public_subnets[count.index]