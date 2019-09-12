# Copyright (C) 2007-2019 Crafter Software Corporation. All Rights Reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.11"
  region  = var.region
}

data "aws_availability_zones" "available" {
}

#------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------
locals {
  vpc_name          = "${var.resource_name_prefix}-vpc"
  cluster_name      = "${var.resource_name_prefix}-cluster"
  azs               = data.aws_availability_zones.available.names
}

#------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------
module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "2.6.0"
  name               = local.vpc_name
  cidr               = var.vpc_cidr
  azs                = local.azs
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

#------------------------------------------------------------------------
# EKS Cluster
#------------------------------------------------------------------------
module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = local.cluster_name
  subnets               = module.vpc.private_subnets
  vpc_id                = module.vpc.vpc_id
  write_aws_auth_config = false
  write_kubeconfig      = false
  worker_groups         = var.eks_worker_groups
}