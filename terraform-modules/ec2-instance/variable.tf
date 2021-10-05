# variable.tf
variable "vpc_id" {}
variable "subnet_id" {}
variable "keyname" {}
variable "ami" {}
variable "vmname" {}
variable "instance_type" {}

variable "ports" {
  type = map(list(string))
}


variable "additional_tags" {
  type = map(string)
}
