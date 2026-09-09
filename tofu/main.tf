data "digitalocean_kubernetes_versions" "selected" {
  version_prefix = var.kubernetes_version_prefix
}

resource "digitalocean_vpc" "cluster" {
  name     = "${var.cluster_name}-vpc"
  region   = var.region
  ip_range = var.vpc_ip_range
}

resource "digitalocean_kubernetes_cluster" "this" {
  name                             = var.cluster_name
  region                           = var.region
  version                          = data.digitalocean_kubernetes_versions.selected.latest_version
  vpc_uuid                         = digitalocean_vpc.cluster.id
  cluster_subnet                   = var.cluster_subnet
  service_subnet                   = var.service_subnet
  auto_upgrade                     = true
  surge_upgrade                    = true
  ha                               = false
  tags                             = var.tags
  destroy_all_associated_resources = false

  maintenance_policy {
    day        = "sunday"
    start_time = "04:00"
  }

  node_pool {
    name       = "general"
    size       = var.node_size
    node_count = var.node_count
    auto_scale = false

    labels = {
      workload = "general"
    }

    tags = var.tags
  }
}

resource "digitalocean_container_registry" "this" {
  name                   = var.container_registry_name
  subscription_tier_slug = "starter"
  region                 = var.region
}

resource "digitalocean_project" "this" {
  name        = var.project_name
  description = "Infrastructure for personal projects on DOKS."
  purpose     = "Other"
  environment = "Development"
  resources   = [digitalocean_kubernetes_cluster.this.urn]
}
