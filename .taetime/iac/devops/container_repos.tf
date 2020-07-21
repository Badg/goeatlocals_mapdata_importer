# This terraform creates all needed container registries in ECR for local
# development.

terraform {
    backend "s3" {
        bucket                = "taev-root-devops"
        encrypt               = true
        key                   = "terraform/bootstrap.tfstate"
        workspace_key_prefix  = "terraform"
        region                = "us-west-2"
        dynamodb_table        = "taev_root_terraform"
        profile               = "taev_root_devops"
        acl                   = "private"
    }
}

provider "aws" {
    region = "us-west-2"
    profile = "taev_root_devops"
    version = "~> 2.58"
}
data "aws_caller_identity" "current" {}


resource "aws_ecr_repository" "goeatlocals_mapdata_importer-importer" {
    name = "goeatlocals_mapdata_importer/importer"

    tags = {
        Name  = "Eat Locals: mapdata importer: importer"
    }

    lifecycle {
        prevent_destroy = true
    }
}
