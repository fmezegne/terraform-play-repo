##### terraform block

terraform {
  backend "s3" {
    bucket = "terra-state-backend"
    key = "terraform-play/first-hands-on/terraform.tfstate"
    region = "us-east-1"
  }
}