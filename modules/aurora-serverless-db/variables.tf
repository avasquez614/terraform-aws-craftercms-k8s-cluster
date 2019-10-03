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

variable "vpc_id" {
  description = "The ID of the VPC where the DB cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets where the DB cluster will be created"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the Aurora serverless cluster (which will be prepended with the resource_name_prefix)"
  default     = "db"
  type        = string
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user."
  type        = string
}

variable "backup_retention_period" {
  description = "The days to retain DB backups for"
  default     = 5
  type        = number
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created (if db_backup_retention_period > 0), in UTC"
  default     = "05:00-07:00"
  type        = string
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which DB system maintenance can occur, in UTC"
  default     = "sun:08:00-sun:08:30"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether a final DB snapshot is created before the DB is deleted"
  default     = true
  type        = bool
}

variable "final_snapshot_identifier" {
  description = "The name of the final DB snapshot when the DB is deleted"
  default     = "craftercms-db-final-snapshot"
  type        = string
}

variable "auto_pause" {
  description = "Whether to enable automatic pause. An Aurora serverless DB cluster can be paused only when it's idle (it has no connections)"
  default     = false
  type        = bool
}

variable "seconds_until_auto_pause" {
  description = "The time, in seconds, before an Aurora DB cluster in serverless mode is paused"
  default     = 21600
  type        = number
}

variable "min_capacity" {
  description = "The minimum capacity, in ACU (Aurora Computing Units), for the DB cluster"
  default     = 2
  type        = number
}

variable "max_capacity" {
  description = "The maximum capacity, in ACU (Aurora Computing Units), for the DB cluster"
  default     = 8
  type        = number
}
