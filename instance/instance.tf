provider "aws" {
 

}
resource "aws_instance" "my-ec2" {
  ami           = "ami-id"
  instance_type = "t2.micro"

tags= {
      Name="MYEC2"
}
}
