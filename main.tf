provider "aws" {
  region = "us-east-1"
}

#Provisioning VPC-one
resource "aws_vpc" "slyth-vpc-one" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "slyth-one"
  }
}

#Provisioning VPC-TWO
resource "aws_vpc" "slyth-vpc-two" {
  cidr_block = "20.0.0.0/16"
  tags = {
    Name = "slyth-two"
  }
}

#Provisioning VPC-three
resource "aws_vpc" "slyth-vpc-three" {
  cidr_block = "30.0.0.0/16"
  tags = {
    Name = "slyth-three"
  }
}

# Provisioning Subnet-ONE
resource "aws_subnet" "slyth-subnet-one" {
  vpc_id     = aws_vpc.slyth-vpc-one.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "slyth-one"
  }
}

# Provisioning Subnet-TWO
resource "aws_subnet" "slyth-subnet-two" {
  vpc_id     = aws_vpc.slyth-vpc-two.id
  cidr_block = "20.0.0.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "slyth-two"
  }
}

# Provisioning Subnet-THREE
resource "aws_subnet" "slyth-subnet-three" {
  vpc_id     = aws_vpc.slyth-vpc-three.id
  cidr_block = "30.0.0.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "slyth-three"
  }
}


# Provisioning IGW-ONE
resource "aws_internet_gateway" "slyth-igw-one" {
  vpc_id = aws_vpc.slyth-vpc-one.id
  
  tags = {
    Name = "slyth-one"
  }
}


#Provisioning SG-ONE
resource "aws_security_group" "slyth-sg-one" {
  name        = "slyth-sg-one"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.slyth-vpc-one.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 23
    to_port          = 23             #for telnet
    protocol         = "tcp"
    cidr_blocks      = ["20.0.0.0/16"]
  }
  
  ingress {
    from_port        = -1
    to_port          = -1          #for icmp
    protocol         = "icmp"
    cidr_blocks      = ["20.0.0.0/16"]
  }
  ingress {
    from_port        = -1
    to_port          = -1          #for icmp
    protocol         = "icmp"
    cidr_blocks      = ["30.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "slyth-one"
  }
}

#Provisioning SG-TWO
resource "aws_security_group" "slyth-sg-two" {
  name        = "slyth-sg-two"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.slyth-vpc-two.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = -1
    to_port          = -1          #for icmp
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/16"]
  }
  ingress {
    from_port        = -1
    to_port          = -1          #for icmp
    protocol         = "icmp"
    cidr_blocks      = ["30.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "slyth-two"
  }
}


#Provisioning SG-THREE
resource "aws_security_group" "slyth-sg-three" {
  name        = "slyth-sg-two"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.slyth-vpc-three.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = -1
    to_port          = -1          #for icmp
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/16"]
  }
  ingress {
    from_port        = -1
    to_port          = -1          #for icmp
    protocol         = "icmp"
    cidr_blocks      = ["20.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "slyth-three"
  }
}


# Create a Transit Gateway
resource "aws_ec2_transit_gateway" "slyth-tgw" {
  tags = {
    Name = "slyth-tgw"
  }
  
}

# Attachment one
resource "aws_ec2_transit_gateway_vpc_attachment" "slyth-attach-one" {
  transit_gateway_id = aws_ec2_transit_gateway.slyth-tgw.id
  vpc_id = aws_vpc.slyth-vpc-one.id

  subnet_ids = [aws_subnet.slyth-subnet-one.id]
  
  tags = {
    Name = "slyth-attachment-one"  
  }
}

# Attachment two
resource "aws_ec2_transit_gateway_vpc_attachment" "slyth-attach-two" {
  transit_gateway_id = aws_ec2_transit_gateway.slyth-tgw.id
  vpc_id = aws_vpc.slyth-vpc-two.id

  subnet_ids = [aws_subnet.slyth-subnet-two.id]

  
  tags = {
    Name = "slyth-attachment-two"  
  }
}

# Attachment three
resource "aws_ec2_transit_gateway_vpc_attachment" "slyth-attach-three" {
  transit_gateway_id = aws_ec2_transit_gateway.slyth-tgw.id
  vpc_id = aws_vpc.slyth-vpc-three.id

  subnet_ids = [aws_subnet.slyth-subnet-three.id]
  
  tags = {
    Name = "slyth-attachment-three"  
  }
}





# Provisioning first EC2 INSTANCE
resource "aws_instance" "slyth-ec2-one" {
  ami = "ami-0fa1de1d60de6a97e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.slyth-subnet-one.id
  vpc_security_group_ids = [aws_security_group.slyth-sg-one.id]
  key_name = "slytherin"
  associate_public_ip_address = true
  
  tags = {
    Name = "slyth-one"
  }
}

# Provisioning SECOND EC2-instance
resource "aws_instance" "slyth-ec2-two" {
  ami = "ami-0fa1de1d60de6a97e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.slyth-subnet-two.id
  vpc_security_group_ids = [aws_security_group.slyth-sg-two.id]
  key_name = "slytherin"
  
  tags = {
    Name = "slyth-two"
  }
}


# Provisioning THIRD EC2-instance
resource "aws_instance" "slyth-ec2-three" {
  ami = "ami-0fa1de1d60de6a97e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.slyth-subnet-three.id
  vpc_security_group_ids = [aws_security_group.slyth-sg-three.id]
  key_name = "slytherin"
  
  tags = {
    Name = "slyth-three"
  }
}