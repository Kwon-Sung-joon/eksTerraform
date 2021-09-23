provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source   = "../module/vpc"
  vpc_cidr = var.vpc_cidr
  alltag   = var.alltag
}

module "public_subnet1" {
  source = "../module/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet1_cidr
  public_subnet_az   = data.aws_availability_zones.available.names["${var.public_subnet1_az}"]
  is_public          = true
  alltag             = var.alltag
}

module "public_subnet2" {
  source = "../module/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet2_cidr
  public_subnet_az   = data.aws_availability_zones.available.names["${var.public_subnet2_az}"]
  is_public          = true
  alltag             = var.alltag

}

module "public_subnet3" {
  source = "../module/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet3_cidr
  public_subnet_az   = data.aws_availability_zones.available.names["${var.public_subnet3_az}"]
  is_public          = true
  alltag             = var.alltag
}

module "private_subnet1" {
  source = "../module/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.private_subnet1_cidr
  public_subnet_az   = data.aws_availability_zones.available.names["${var.private_subnet1_az}"]
  is_public          = false
  alltag             = var.alltag
}


module "private_subnet2" {
  source = "../module/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.private_subnet2_cidr
  public_subnet_az   = data.aws_availability_zones.available.names["${var.private_subnet2_az}"]
  is_public          = false
  alltag             = var.alltag
}

module "private_subnet3" {
  source = "../module/subnet"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.private_subnet3_cidr
  public_subnet_az   = data.aws_availability_zones.available.names["${var.private_subnet3_az}"]
  is_public          = false
  alltag             = var.alltag
}
module "public_subnet_rtb_igw" {
  source = "../module/rtb_igw"
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
  subnet_ids = [
    module.public_subnet1.subnet_id,
    module.public_subnet2.subnet_id,
    module.public_subnet3.subnet_id,
    module.private_subnet1.subnet_id,
    module.private_subnet2.subnet_id,
    module.private_subnet3.subnet_id

  ]
  is_publics = [
    module.public_subnet1.is_public,
    module.public_subnet2.is_public,
    module.public_subnet3.is_public,

    module.private_subnet1.is_public,
    module.private_subnet2.is_public,
    module.private_subnet3.is_public

  ]
  alltag = var.alltag
}

module "iam" {
  source = "../module/iam"
  alltag = var.alltag

}

module "eks_cluster" {
  source     = "../module/eks_cluster"
  depends_on = [module.iam]

  eks_cluster_iam_role_arn = module.iam.eks_cluster_iam_role_arn
  pub_subnet_id1           = module.public_subnet1.subnet_id
  pub_subnet_id2           = module.public_subnet2.subnet_id
  pub_subnet_id3           = module.public_subnet3.subnet_id

  pri_subnet_id1 = module.private_subnet1.subnet_id
  pri_subnet_id2 = module.private_subnet2.subnet_id
  pri_subnet_id3 = module.private_subnet3.subnet_id
  alltag         = var.alltag
}


module "eks_node_groups" {
  source                       = "../module/eks_node_groups"
  depends_on                   = [module.iam]
  eks_node_groups_iam_role_arn = module.iam.eks_node_groups_iam_role_arn
  alltag                       = var.alltag
  cluster_name                 = module.eks_cluster.cluster_name
  subnet_id1                   = module.public_subnet1.subnet_id
  subnet_id2                   = module.public_subnet2.subnet_id
  subnet_id3                   = module.public_subnet3.subnet_id

}


module "ecr_repos" {
  source         = "../module/ecr"
  ecr-repos-name = var.ecr-repose-name
}
