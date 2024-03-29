resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.alltag}-EKS-CLUSTER"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version = "1.20"
  vpc_config {
    subnet_ids = [var.subnet_id1, var.subnet_id2]
    endpoint_private_access=true
   # endpoint_public_access=true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-role-AmazonEKSVPCResourceController,
  ]
  
  tags = {
    Name = "${var.alltag}-EKS-CLUSTER",
Owner = "ksj"
  }
  provisioner "local-exec" {
        command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks-cluster.id}"
  }

}


resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.alltag}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY


  tags = {
    Name = "${var.alltag}-IAM-ROLE-EKS-CLUSTER",
Owner= "ksj"
  }
}

resource "aws_iam_role_policy_attachment" "eks-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-role-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}
