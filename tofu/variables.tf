variable "project_name" {
  description = "DigitalOcean project name."
  type        = string
  default     = "jon-hobby"
}

variable "cluster_name" {
  description = "DOKS cluster name."
  type        = string
  default     = "jon-hobby"
}

variable "container_registry_name" {
  description = "Globally unique DigitalOcean Container Registry name."
  type        = string
  default     = "jonsolakis"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.container_registry_name))
    error_message = "container_registry_name must be 2-63 lowercase letters, numbers, or hyphens; it must start with a letter and end with a letter or number."
  }
}

variable "region" {
  description = "DigitalOcean region slug."
  type        = string
  default     = "tor1"
}

variable "kubernetes_version_prefix" {
  description = "Pinned Kubernetes minor series; the newest available patch in this series is selected."
  type        = string
  default     = "1.36."
}

variable "node_size" {
  description = "Worker Droplet size."
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "node_count" {
  description = "Fixed worker count. Two workers provide basic workload redundancy."
  type        = number
  default     = 2

  validation {
    condition     = var.node_count >= 1
    error_message = "node_count must be at least one."
  }
}

variable "vpc_ip_range" {
  description = "Private VPC range. Changing it replaces the VPC."
  type        = string
  default     = "10.10.0.0/20"
}

variable "cluster_subnet" {
  description = "Immutable pod subnet for VPC-native networking."
  type        = string
  default     = "172.20.0.0/16"
}

variable "service_subnet" {
  description = "Immutable Kubernetes Service subnet."
  type        = string
  default     = "172.21.0.0/19"
}

variable "tags" {
  description = "Tags applied to the cluster and workers."
  type        = list(string)
  default     = ["hobby", "managed-by-opentofu"]
}
