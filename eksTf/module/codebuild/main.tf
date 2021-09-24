#S3 bucket for Pipeline Artifact store.
resource "aws_s3_bucket" "s3_bucekt" {
  bucket = var.bucketName

}
#IAM Policy for Code Pipeline service Role
resource "aws_iam_role_policy" "codePipelineServiceRolePolicy" {
  role = aws_iam_role.codePipelineServiceRole.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "1",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "2",
          "Effect" : "Allow",
          "Action" : "s3:PutObject",
          "Resource" : [
            "arn:aws:s3:::codepipeline*",
            "arn:aws:s3:::elasticbeanstalk*"
          ]
        },
        {
          "Sid" : "3",
          "Effect" : "Allow",
          "Action" : [
            "codedeploy:CreateDeployment",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision",
            "elasticbeanstalk:*",
            "ec2:*",
            "elasticloadbalancing:*",
            "autoscaling:*",
            "cloudwatch:*",
            "s3:*",
            "sns:*",
            "ecs:*",
            "iam:PassRole",
            "lambda:InvokeFunction",
            "lambda:ListFunctions",
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "codecommit:CancelUploadArchive",
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:UploadArchive"


          ],
          "Resource" : "*"
        }
      ]
  })
}


#IAM Role for Code Pipeline service Role
resource "aws_iam_role" "codePipelineServiceRole" {
  name               = "${var.alltag}-codePipelineServiceRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    Name  = "${var.alltag}-codePipelineServiceRole",
    Owner = "ksj"
  }
}

#IAM Policy Attachment for Code Pipeline service Role
resource "aws_iam_role_policy_attachment" "code-pipeline-AWSCodePipelineFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
  role       = aws_iam_role.codePipelineServiceRole.name
}


#IAM ROle for Code Build service role
resource "aws_iam_role" "codeBuildServiceRole" {
  name = "${var.alltag}-codeBuildServiceRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    Name  = "${var.alltag}-codeBuildServiceRole",
    Owner = "ksj"
  }
}

#IAM Policy for Code Build service role
resource "aws_iam_role_policy" "codeBuildServiceRolePolicy" {
  role   = aws_iam_role.codeBuildServiceRole.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Action": [
		"logs:CreateLogGroup",
		"logs:CreateLogStream",
		"logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${var.accountId}:log-group:/aws/codebuild/${var.projectBuild}",
                "arn:aws:logs:${var.region}:${var.accountId}:log-group:/aws/codebuild/${var.projectBuild}:*",
                "arn:aws:logs:${var.region}:${var.accountId}:log-group:/aws/codebuild/${var.projectApply}:*",
                "arn:aws:logs:${var.region}:${var.accountId}:log-group:/aws/codebuild/${var.projectApply}:*"
            ]
        },
        {
            "Sid": "2",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucketName}*"
            ]
        },
        {
            "Sid": "3",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:${var.region}:${var.accountId}:parameter/CodeBuild/*"
            ]
        },
        {
            "Sid": "4",
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
            ],
            "Resource": [
                "arn:aws:eks:${var.region}:${var.accountId}:cluster/${var.cluster}"
            ]
        },
        {
            "Sid": "5",
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
		"ecr:BatchGetImage",
		"ecr:GetDownloadUrlForLayer",
		"ecr:PutImage",
		"ecr:InitiateLayerUpload",
		"ecr:UploadLayerPart",
		"ecr:CompleteLayerUpload",
		"ecr:GetAuthorizationToken"
            ],
            "Resource": "*" 
        }
      ]
}
EOF
}

#Code Build Project
resource "aws_codebuild_project" "codeBuildProjectAppPushToECR" {
  name         = "eks-app-build"
  service_role = aws_iam_role.codeBuildServiceRole.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec/buildspec-build.yaml"

  }
build_batch_config {
timeout_in_mins = "15"
service_role = aws_iam_role.codeBuildServiceRole.arn
}
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = "true"
    environment_variable {
      name  = "Branch"
      value = var.branch
    }

    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = var.cluster
    }
    environment_variable {
      name  = "REGION"
      value = var.region
    }
    environment_variable {
      name  = "KUBECTL_VERSION"
      value = var.kubectl_version
    }
    environment_variable {
      name  = "REGISTORY_NAME"
      value = var.ecrName
    }
    environment_variable {
      name  = "REGISTORY_URL"
      value = var.ecrUrl
    }

  }
}

#Code Build Project
resource "aws_codebuild_project" "codeBuildProjectAppApplyToEKS" {
  name         = "eks-app-apply"
  service_role = aws_iam_role.codeBuildServiceRole.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec/buildspec-apply.yaml"

  }
build_batch_config {
  timeout_in_mins = "15"
  service_role = aws_iam_role.codeBuildServiceRole.arn

}
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = "true"
    environment_variable {
      name  = "Branch"
      value = var.branch
    }

    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = var.cluster
    }
    environment_variable {
      name  = "REGION"
      value = var.region
    }
    environment_variable {
      name  = "KUBECTL_VERSION"
      value = var.kubectl_version
    }
    environment_variable {
      name  = "REGISTORY_NAME"
      value = var.ecrName
    }
    environment_variable {
      name  = "REGISTORY_URL"
      value = var.ecrUrl
    }

  }
}


#Main process of Code Pipeline

resource "aws_codepipeline" "codePipeline" {
  artifact_store {
    location = aws_s3_bucket.s3_bucekt.bucket
    type     = "S3"
  }
  name     = "codePipeline"
  role_arn = aws_iam_role.codePipelineServiceRole.arn
  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        FullRepositoryId = "${var.ecrName}"
        BranchName       = "${var.branch}"
      }
    }
  }
  stage {
    name = "buildAppPushToECR"
    action {
      name             = "CodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["CodebuildOutputBuild"]
      run_order        = "1"
      configuration = {
        ProjectName = aws_codebuild_project.codeBuildProjectAppPushToECR.id
      }
    }
  }

  stage {
    name = "applyAppToEKS"
    action {
      name             = "CodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["CodebuildOutputApply"]
      run_order        = "1"
      configuration = {
        ProjectName = aws_codebuild_project.codeBuildProjectAppApplyToEKS.id
      }
    }
  }

}
