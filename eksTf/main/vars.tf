data "aws_availability_zones" "available" {
  state = "available"
}

variable "alltag" {
  description = "name"
  default     = "ksj-TF"
}

variable "vpc_cidr" {
  description = "VPC CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "Public Subnet CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.0.0/24"
}

variable "public_subnet2_cidr" {
  description = "Public Subnet CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.1.0/24"
}

variable "public_subnet3_cidr" {
  description = "Public Subnet CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.2.0/24"
}



variable "public_subnet1_az" {
  description = "Public Subnet AZ : 0(A)~3(D)"
  default     = 0
}

variable "public_subnet2_az" {
  description = "Public Subnet AZ : 0(A)~3(D)"
  default     = 1
}

variable "public_subnet3_az" {
  description = "Public Subnet AZ : 0(A)~3(D)"
  default     = 2
}

variable "private_subnet1_cidr" {
  description = "Public Subnet CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.3.0/24"
}
variable "private_subnet2_cidr" {
  description = "Private Subnet CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.4.0/24"
}

variable "private_subnet3_cidr" {
  description = "Private Subnet CIDR BLOCK : x.x.x.x/x"
  default     = "192.168.5.0/24"
}


variable "private_subnet1_az" {
  description = "Private Subnet AZ : 0(A)~3(D)"
  default     = 0
}

variable "private_subnet2_az" {
  description = "Private Subnet AZ : 0(A)~3(D)"
  default     = 1
}

variable "private_subnet3_az" {
  description = "Private Subnet AZ : 0(A)~3(D)"
  default     = 2
}


variable "ecr-repose-name" {
  description = "ECR Repository Name"
  default     = "ksj-ecr-repo"

}
