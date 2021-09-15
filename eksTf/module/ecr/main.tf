
resource "aws_ecr_repository" "ecr-repos" {
  name                 = var.ecr-repos-name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true


  }
  provisioner "local-exec" {
    command = <<EOT
ECR_HOST=`aws ecr describe-repositories --repository-names ${var.ecr-repos-name} --region ap-northeast-2 --query repositories[].repositoryUri --output text`;
docker pull kofdx7/apache:2 && docker tag kofdx7/apache:2 $ECR_HOST\:apache2;
docker pull kofdx7/tomcat:9.0 && docker tag kofdx7/tomcat:9.0 $ECR_HOST\:tomcat9;
docker login -u AWS -p $(aws ecr get-login-password --region ap-northeast-2) $ECR_HOST;
docker push $ECR_HOST\:apache2;
docker push $ECR_HOST\:tomcat9;
EOT

  }



}
