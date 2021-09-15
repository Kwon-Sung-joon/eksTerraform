variable "alltag" {}
variable "vpc_id" {}
variable "igw_id" {}

variable "subnet_ids" {
  type = list(string)

}

variable "is_publics" {
  type = list(string)
}


