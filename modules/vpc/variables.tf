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

variable "azs" {
  description = "The availability zones where the infraestructure will be located"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block for the cloud VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "private_subnets_cidrs" {
  description = "The CIDRs of private subnets of the cloud VPC. The default values allow 4094 hosts per subnet"
  default     = ["10.0.16.0/20", "10.0.32.0/20"]
  type        = list(string)
}

variable "public_subnets_cidrs" {
  description = "The CIDRs of public subnets of the cloud VPC. The default values allow 4094 hosts per subnet"
  default     = ["10.0.48.0/20", "10.0.64.0/20"]
  type        = list(string)
}