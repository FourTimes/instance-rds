resource "aws_instance" "tf" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.tf.id]
  key_name               = var.keyname
  tags = merge({ Name = "${var.vmname}" }, tomap(var.additional_tags))
}

# aws_security_group
resource "aws_security_group" "tf" {
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  name       = "${var.vmname}-security-group"
  tags = merge({ Name = "${var.vmname}" }, tomap(var.additional_tags))
}