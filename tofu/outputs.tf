output "cluster_id" {
  description = "DOKS cluster ID, accepted by doctl kubeconfig commands."
  value       = digitalocean_kubernetes_cluster.this.id
}

output "cluster_name" {
  value = digitalocean_kubernetes_cluster.this.name
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.this.endpoint
}

output "container_registry_name" {
  value = digitalocean_container_registry.this.name
}

output "container_registry_endpoint" {
  value = digitalocean_container_registry.this.endpoint
}

output "kubernetes_version" {
  value = digitalocean_kubernetes_cluster.this.version
}

output "vpc_id" {
  value = digitalocean_vpc.cluster.id
}
