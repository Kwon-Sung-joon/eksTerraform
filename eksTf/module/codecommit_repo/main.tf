resource "aws_codecommit_repository" "codecommit_repo" {
  repository_name = var.repo_name
  description     = var.repo_desc

  tags = {
    Name  = "${var.alltag}-CODECOMMIT-REPO",
    Owner = "ksj"
  }
}
