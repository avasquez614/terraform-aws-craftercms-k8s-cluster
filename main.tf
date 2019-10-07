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

# ----------------------------------------------------------------------------------------------------------------------
# This is an example of a Crafter CMS Kubernetes cluster that uses an Elasticsearch Domain with just 1 instance and an
# Aurora Serverless DB. Take a look at the examples/ folder for more complex examples.

# PLEASE make sure to change the db username and password when using this example!!!
# ----------------------------------------------------------------------------------------------------------------------

locals {
  region      = "us-east-1"
  azs         = ["us-east-1a", "us-east-1b"]
  k8s_version = "1.14"
}

module "vpc" {
  source               = "./modules/vpc"
  resource_name_prefix = var.resource_name_prefix
  region               = local.region
  azs                  = local.azs
}

module "eks" {
  source               = "./modules/eks-cluster"
  resource_name_prefix = var.resource_name_prefix
  cluster_version      = local.k8s_version
  region               = local.region
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.vpc_private_subnets
  worker_groups        = [
    {
      name                  = "az1-k8s-support-workers-v${local.k8s_version}"
      subnets               = [module.vpc.vpc_private_subnets[0]]
      instance_type         = "t3a.small"
      asg_min_size          = 1
      asg_desired_capacity  = 1
      asg_max_size          = 3
      root_volume_size      = 20
      kubelet_extra_args    = "--node-labels=node-type=k8s-support"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    },
    {
      name                  = "az2-k8s-support-workers-v${local.k8s_version}"
      subnets               = [module.vpc.vpc_private_subnets[1]]
      instance_type         = "t3a.small"
      asg_min_size          = 1
      asg_desired_capacity  = 1
      asg_max_size          = 3
      root_volume_size      = 20
      kubelet_extra_args    = "--node-labels=node-type=k8s-support"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    },
    {
      name                  = "az1-authoring-workers-v${local.k8s_version}"
      subnets               = [module.vpc.vpc_private_subnets[0]]
      instance_type         = "t3a.xlarge"
      asg_min_size          = 1
      asg_desired_capacity  = 1
      asg_max_size          = 20
      root_volume_size      = 20
      kubelet_extra_args    = "--node-labels=node-type=authoring"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    },
    {
      name                  = "az2-authoring-workers-v${local.k8s_version}"
      subnets               = [module.vpc.vpc_private_subnets[1]]
      instance_type         = "t3a.xlarge"
      asg_min_size          = 1
      asg_desired_capacity  = 1
      asg_max_size          = 20
      root_volume_size      = 20
      kubelet_extra_args    = "--node-labels=node-type=authoring"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    },
    {
      name                  = "az1-delivery-workers-v${local.k8s_version}"
      subnets               = [module.vpc.vpc_private_subnets[0]]
      instance_type         = "t3a.medium"
      asg_min_size          = 1
      asg_desired_capacity  = 1
      asg_max_size          = 20
      root_volume_size      = 20
      kubelet_extra_args    = "--node-labels=node-type=delivery"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    },
    {
      name                  = "az2-delivery-workers-v${local.k8s_version}"
      subnets               = [module.vpc.vpc_private_subnets[1]]
      instance_type         = "t3a.medium"
      asg_min_size          = 1
      asg_desired_capacity  = 1
      asg_max_size          = 20
      root_volume_size      = 20
      kubelet_extra_args    = "--node-labels=node-type=delivery"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    }
  ]
}

module "es" {
  source     = "./modules/elasticsearch-domain"
  region     = local.region
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.vpc_private_subnets
}

module "db" {
  source          = "./modules/aurora-serverless-db"
  region          = local.region
  azs             = local.azs
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.vpc_private_subnets
  master_username = "example_user"
  master_password = "example_password"
}
