output "k8s_master_ip" {
  value = yandex_compute_instance.k8s_master.network_interface[0].ip_address
}

output "k8s_app_ip" {
  value = yandex_compute_instance.k8s_app.network_interface[0].ip_address
}

output "srv_ip" {
  value = yandex_compute_instance.srv.network_interface[0].nat_ip_address
}

output "srv_internal_ip" {
  value = yandex_compute_instance.srv.network_interface[0].ip_address
}
