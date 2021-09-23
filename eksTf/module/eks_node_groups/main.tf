resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.alltag}-eks-node-groups"
  node_role_arn   = var.eks_node_groups_iam_role_arn
  subnet_ids      = [var.subnet_id1, var.subnet_id2, var.subnet_id3]


  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  tags = {
    Name  = "${var.alltag}-eks-node-group"
    Owner = "ksj"
  }
}




