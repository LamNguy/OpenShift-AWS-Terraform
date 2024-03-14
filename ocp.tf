resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  count         = var.number_of_instances
  subnet_id     = var.subnet_id
  instance_type = var.instance_type
  key_name      = var.ami_key_pair_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  user_data = "${file("ocp.sh")}"
  tags = {
    Name = "ocp_deployment"
  }
}

data "aws_security_group" "existing_sg" {
  name = "ssh"  # Replace with the name of your security group
  id = "sg-0fdb32e826b44ab40"
}

