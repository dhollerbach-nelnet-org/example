locals {
  name = "github-runner-${var.github_commit_sha}"

  tags = {
    Environment = "github-runner"
    Terraform   = "true"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Type = "private"
  }
}

#------------------------------------------------------------------------------
# VARIABLES
#------------------------------------------------------------------------------
variable "github_access_token" {
  description = "(Required) The GitHub access token. Can be a personal access token or a fine-grained access token."
  type        = string
}

variable "github_commit_sha" {
  description = "(Required) The GitHub commit sha. Can be a UUID if desired."
  type        = string
}

variable "github_organization" {
  default     = "dhollerbach-nelnet-org"
  description = "(Required) The GitHub organization."
  type        = string
}

variable "github_repository" {
  default     = "example"
  description = "(Required) The GitHub repository."
  type        = string
}

variable "vpc_id" {
  description = "(Required) The VPC ID to create the ECS Fargate services in."
  type        = string
}

#------------------------------------------------------------------------------
# ECS
#------------------------------------------------------------------------------
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.1"

  cluster_name = local.name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    (local.name) = {
      cpu    = 512
      memory = 1024

      container_definitions = {
        github-runner = {
          cpu       = 256
          memory    = 512
          essential = true
          image     = "dhollerbach/github-runner:latest"
          environment = [
            {
              name  = "RUNNER_ALLOW_RUNASROOT"
              value = true
            },
            {
              name  = "GITHUB_ACTIONS_RUNNER_CONTEXT"
              value = "https://github.com/${var.github_organization}/${var.github_repository}"
            },
            {
              name  = "GITHUB_ACCESS_TOKEN"
              value = var.github_access_token
            }
          ]
          readonly_root_filesystem = false
        }
      }

      runtime_platform = {
        cpu_architecture        = "ARM64"
        operating_system_family = "LINUX"
      }

      subnet_ids = data.aws_subnets.private.ids
      security_group_rules = {
        ingress_all = {
          type        = "ingress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      wait_for_steady_state = true
      wait_until_stable     = true
    }

  }

  tags = local.tags
}
