# Instance One

module "vm-instance-one" {
  source        = "./terraform-modules/ec2-instance"
  vpc_id        = aws_vpc.vpc.id
  subnet_id     = aws_subnet.s1.id
  keyname       = "traacs-new"
  ami           = "ami-0a23ccb2cdd9286bb"
  vmname        = "jenkins-server"
  instance_type = "t2.micro"
  ports = {
    "22"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
  additional_tags = {
    environment = "demo"
    Owner       = "htc"
  }
}

# Instance Two

module "vm-instance-two" {
  source        = "./terraform-modules/ec2-instance"
  vpc_id        = aws_vpc.vpc.id
  subnet_id     = aws_subnet.s2.id
  keyname       = "traacs-new"
  ami           = "ami-0a23ccb2cdd9286bb"
  vmname        = "tomcat-server"
  instance_type = "t2.micro"
  ports = {
    "22"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
  additional_tags = {
    environment = "demo"
    Owner       = "htc"
  }
}

