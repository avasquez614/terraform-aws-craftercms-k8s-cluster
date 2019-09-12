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
  region = "us-east-1"
}

module "eks" {
  source = "./modules/eks-cluster"
  region = local.region
}

module "es" {
  source     = "./modules/elasticsearch-domain"
  region     = local.region
  vpc_id     = module.eks.vpc_id
  subnet_ids = module.eks.vpc_private_subnets
}

module "db" {
  source          = "./modules/aurora-serverless-db"
  region          = local.region
  vpc_id          = module.eks.vpc_id
  subnet_ids      = module.eks.vpc_private_subnets
  master_username = "example_user"
  master_password = "example_password"
}
