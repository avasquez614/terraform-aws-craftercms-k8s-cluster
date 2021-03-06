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

variable "resource_name_prefix" {
  description = "The prefix used in the names of most infraestructure resources"
  default     = "craftercms"
  type        = string
}

variable "region" {
  description = "The AWS region where the infraestructure will be located"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to place the EKS cluster and workers within."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.14"
}

variable "worker_groups" {
  description = "The EKS worker groups. See https://github.com/terraform-aws-modules/terraform-aws-eks on the format of worker_groups"
  type        = any
  default     = []
}
