output "eks_node_groups_iam_role_arn" {
  value = aws_iam_role.eks-node-group-iam-role.arn

}

output "eks_cluster_iam_role_arn" {
  value = aws_iam_role.eks-cluster-role.arn
}
