provider "aws" {
  region = "eu-central-1"
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = "arn:aws:iam::181999802870:role/EKS"

  vpc_config {
    subnet_ids = ["subnet-a3de92c8", "subnet-abe763d6"]
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.example.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.example.certificate_authority.0.data}"
}
