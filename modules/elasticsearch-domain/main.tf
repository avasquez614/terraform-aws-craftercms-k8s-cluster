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

data "aws_caller_identity" "current" {
}

data "aws_subnet" "subnet" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

#------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------
locals {
  es_domain_name    = "${var.resource_name_prefix}-${var.es_instance_name}"
}

#------------------------------------------------------------------------
# Elasticsearch Security Group
#------------------------------------------------------------------------
resource "aws_security_group" "es_sg" {
  name        = "${local.es_domain_name}-es-sg"
  description = "Allows access to Elasticsearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = data.aws_subnet.subnet.*.cidr_block
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#------------------------------------------------------------------------
# Elasticsearch Domain
#------------------------------------------------------------------------
resource "aws_elasticsearch_domain" "es" {
  domain_name           = local.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = var.azs_count > 1

    zone_awareness_config {
      availability_zone_count = var.azs_count
    }
  }

  vpc_options {
    subnet_ids         = slice(var.subnet_ids, 0, var.azs_count)
    security_group_ids = [aws_security_group.es_sg.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${local.es_domain_name}/*"
      }
  ]
}
  CONFIG
}