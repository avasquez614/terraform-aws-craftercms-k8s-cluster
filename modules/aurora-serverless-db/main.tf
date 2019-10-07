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

  required_providers {
    aws = ">= 2.31.0"
  }
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
  db_instance_name = "${var.resource_name_prefix}-${var.cluster_name}"
}

#------------------------------------------------------------------------
# AWS RDS Security Group
#------------------------------------------------------------------------
resource "aws_security_group" "db_sg" {
  count       = var.security_group_id != "" ? 0 : 1
  name        = "${local.db_instance_name}-sg"
  description = "Allows access to ${local.db_instance_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
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
# AWS RDS DB
#------------------------------------------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  count       = var.db_subnet_group_name != "" ? 0 : 1
  name        = "${local.db_instance_name}-subnet-group"
  description = "DB Subnet Group for ${local.db_instance_name}"
  subnet_ids  = var.subnet_ids
}

resource "aws_rds_cluster" "db" {
  cluster_identifier              = local.db_instance_name
  availability_zones              = var.azs
  engine                          = "aurora"
  engine_mode                     = "serverless"
  master_username                 = var.master_username
  master_password                 = var.master_password
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.final_snapshot_identifier
  db_subnet_group_name            = var.db_subnet_group_name != "" ? var.db_subnet_group_name : aws_db_subnet_group.db_subnet_group.0.name
  vpc_security_group_ids          = [var.security_group_id != "" ? var.security_group_id : aws_security_group.db_sg.0.id]

  scaling_configuration {
    auto_pause               = var.auto_pause
    min_capacity             = var.min_capacity
    max_capacity             = var.max_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
  }
}