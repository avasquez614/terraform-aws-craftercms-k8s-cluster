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

output "vpc_id" {
  description = "The ID of the cluster VPC"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "The IDs of private subnets of the cluster VPC"
  value       = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "The IDs of the private subnets of the cluster VPC"
  value       = module.vpc.public_subnets
}

output "cluster_endpoint" {
  description = "Endpoint for EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}