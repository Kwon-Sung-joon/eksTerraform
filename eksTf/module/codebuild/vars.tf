variable "alltag" {}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "accountId" {
  type    = string
  default = "049474991519"
}

variable "projectBuild" {
  type    = string
  default = "test"
}

variable "projectApply" {
  type    = string
  default = "test"

}
variable "cluster" {}

variable "bucketName" {
  type    = string
  default = "ksj-pipieline-manifest"
}

variable "branch" {
  type    = string
  default = "master"
}
variable "kubectl_version" {
  type    = string
  default = "1.20"
}

variable "ecrName" {}

variable "ecrUrl" {}

