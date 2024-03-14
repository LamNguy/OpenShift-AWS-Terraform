provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-southeast-1"
}

variable "access_key" {
  description = "Access key to AWS console"
  default     = "<enter access key>"
}
variable "secret_key" {
  description = "Secret key to AWS console"
  sensitive   = true
}

variable "instance_type" {
  default = "t2.medium"
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will be created in"
  default     = "subnet-0327407d698c693d9"
}

variable "ami_id" {
  description = "The AMI to use"
  default     = "ami-0123c9b6bfb7eb962"
}

variable "number_of_instances" {
  description = "number of instances to be created"
  default     = 1
}


variable "ami_key_pair_name" {
  default = "ocp"
}