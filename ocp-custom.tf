resource "aws_vpc" "ocp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # Enable internal DNS
  enable_dns_hostnames = true
  # tags = {
  #   Name = "ocp4-tznnz-vpc" # Your desired VPC name
  # }
}

resource "aws_internet_gateway" "ocp_vpc_igw" {
  vpc_id = aws_vpc.ocp_vpc.id
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.ocp_vpc.id
  cidr_block        = "10.0.128.0/18"
  availability_zone = "ap-southeast-1a" # Adjust for your AZ
  # tags = {
  #   Name = "ocp4-tznnz-public-ap-southeast-1a"
  # }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.ocp_vpc.id
  cidr_block        = "10.0.192.0/18"
  availability_zone = "ap-southeast-1b" # Adjust for your AZ
  # tags = {
  #   Name = "ocp4-tznnz-public-ap-southeast-1b"
  # }
  map_public_ip_on_launch = true
}


# Private Subnet
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.ocp_vpc.id
  cidr_block        = "10.0.0.0/18"
  availability_zone = "ap-southeast-1a"
  # tags = {
  #   Name = "ocp4-tznnz-private-ap-southeast-1a"
  # }
}

# Private Subnet
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.ocp_vpc.id
  cidr_block        = "10.0.64.0/18"
  availability_zone = "ap-southeast-1b"
  # tags = {
  #   Name = "ocp4-tznnz-private-ap-southeast-1b"
  # }
}

# Public Route Table 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ocp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ocp_vpc_igw.id
  }

  tags = {
    Name = "ocp4-tznnz-public"
  }
}


# Public Subnet Route Association
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

# Public Subnet Route Association
resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}



# Elastic IP Allocation (for NAT Gateway's public IP)
resource "aws_eip" "nat_eip_a" {
  domain = "vpc" # Allocate an EIP in your VPC
  tags = {
    Name = "ocp4-tznnz-eip-ap-southeast-1a"
  }
}

# Elastic IP Allocation (for NAT Gateway's public IP)
resource "aws_eip" "nat_eip_b" {
  domain = "vpc" # Allocate an EIP in your VPC
  tags = {
    Name = "ocp4-tznnz-eip-ap-southeast-1b"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id          #Assign the EIP
  subnet_id     = aws_subnet.public_subnet_a.id # Place in a public subnet
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id          #Assign the EIP
  subnet_id     = aws_subnet.public_subnet_b.id # Place in a public subnet
}


resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.ocp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
  tags = {
    Name = "ocp4-tznnz-private-ap-southeast-1a-route-table"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.ocp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = {
    Name = "ocp4-tznnz-private-ap-southeast-1b-route-table"
  }
}

# Private Subnet Route Association
resource "aws_route_table_association" "private_assoc_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

# Private Subnet Route Association
resource "aws_route_table_association" "private_assoc_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route53_zone" "ocp_domain" {
  name = "ocp4.svtech.gay"
  vpc {
    vpc_id = aws_vpc.ocp_vpc.id
  }
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  count                  = var.number_of_instances
  subnet_id              = var.subnet_id
  instance_type          = var.instance_type
  key_name               = var.ami_key_pair_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  user_data              = data.template_file.user_data.rendered
  # "${file("ocp.sh")}"
  tags = {
    Name = "ocp_deployment"
  }
}

data "aws_security_group" "existing_sg" {
  name = "ssh" # Replace with the name of your security group
  id   = "sg-0fdb32e826b44ab40"
}


data "template_file" "user_data" {
  template = file("ocp-custom.sh")
  vars = {
    route53_zone_id      = aws_route53_zone.ocp_domain.zone_id
    aws_subnet_private_a = aws_subnet.private_subnet_a.id
    aws_subnet_private_b = aws_subnet.private_subnet_b.id
    aws_subnet_public_a  = aws_subnet.public_subnet_a.id
    aws_subnet_public_b  = aws_subnet.public_subnet_b.id
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.ocp_vpc.id # Replace with your VPC's ID
  service_name    = "com.amazonaws.ap-southeast-1.s3"
  route_table_ids = [aws_route_table.private_route_table_a.id, aws_route_table.private_route_table_b.id, aws_route_table.public_route_table.id] # Replace if needed

