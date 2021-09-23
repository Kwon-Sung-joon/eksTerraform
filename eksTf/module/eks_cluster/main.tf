resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.alltag}-EKS-CLUSTER"
  role_arn = var.eks_cluster_iam_role_arn
  version = "1.20"

  vpc_config {
    subnet_ids = [var.pub_subnet_id1, var.pub_subnet_id2, var.pub_subnet_id3, var.pri_subnet_id1, var.pri_subnet_id2, var.pri_subnet_id3]
  }
  tags = {
    Name = "${var.alltag}-EKS-CLUSTER",
Owner = "ksj"
  }
  provisioner "local-exec" {
        command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks-cluster.id} --region ap-northeast-2"
  }

}


