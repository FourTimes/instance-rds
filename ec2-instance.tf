# Instance One

module "vm-instance-one" {
  source        = "./terraform-modules/ec2-instance"
  vpc_id        = "xx"
  subnet_id     = "xx"
  keyname       = "xx"
  ami           = "xx"
  vmname        = "xx"
  instance_type = "xx"
  ports = {
    "443"  = ["0.0.0.0/0"]
    "22"   = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
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
  vpc_id        = "yy"
  subnet_id     = "yy"
  keyname       = "yy"
  ami           = "yy"
  vmname        = "yy"
  instance_type = "yy"
  ports = {
    "443"  = ["0.0.0.0/0"]
    "22"   = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
  additional_tags = {
    environment = "demo"
    Owner       = "htc"
  }
}

