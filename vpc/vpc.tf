provider "aws" {
  

}

resource "aws_vpc"  "custom-vpc" {
  cidr_block = "10.0.0.0/16"
tags= {
 Name= "custom-vpc"
}
}

resource "aws_internet_gateway" "custom-igw" {
 vpc_id = aws_vpc.custom-vpc.id
tags = {
 Name = "customigw"
}
}

resource "aws_subnet" "websubnet" {
 cidr_block = "10.0.0.0/20"
 vpc_id = aws_vpc.custom-vpc.id
 availability_zone = "az-name"
tags = {
Name = "Publicsubnet"
}
}

resource "aws_subnet" "appsubnet" {
 cidr_block = "10.0.16.0/20"
 vpc_id = aws_vpc.custom-vpc.id
 availability_zone = "az-name"
tags= {
Name= "Privatesubnet"
}
}

resource "aws_route_table" "public-rt" {
vpc_id= aws_vpc.custom-vpc.id
route{
cidr_block= "0.0.0.0/0"
gateway_id = aws_internet_gateway.custom-igw.id
}
}

resource "aws_route_table" "private-rt" {
vpc_id= aws_vpc.custom-vpc.id
}

resource "aws_route_table_association" "public-rt-association-web" {
 subnet_id = aws_subnet.websubnet.id
 route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rt-association-app" {
  subnet_id      = aws_subnet.appsubnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_security_group" "websg" {
 name=  "web-sg"
vpc_id =  aws_vpc.custom-vpc.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "appsg" {
 name=  "app-sg"
vpc_id =  aws_vpc.custom-vpc.id
  ingress {
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/20"]
}
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
}
}
