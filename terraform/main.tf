resource "yandex_vpc_network" "network" {
  name = "devops-network"
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "devops-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat_route" {
  name       = "nat-route"
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "devops-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route.id
}

resource "yandex_vpc_address" "srv_ip" {
  name = "srv-static-ip"
  external_ipv4_address {
    zone_id = var.zone
  }
}

resource "yandex_compute_instance" "k8s_master" {
  name                      = "k8s-master"
  hostname                  = "k8s-master"
  platform_id               = "standard-v1"
  zone                      = var.zone
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd83vkt13re8v8cdapql"
      size     = 20
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.0.1.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "k8s_app" {
  name                      = "k8s-app"
  hostname                  = "k8s-app"
  platform_id               = "standard-v1"
  zone                      = var.zone
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd83vkt13re8v8cdapql"
      size     = 20
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.0.1.11"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "srv" {
  name                      = "srv"
  hostname                  = "srv"
  platform_id               = "standard-v1"
  zone                      = var.zone
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd83vkt13re8v8cdapql"
      size     = 30
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet.id
    nat            = true
    ip_address     = "10.0.1.20"
    nat_ip_address = yandex_vpc_address.srv_ip.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    srv_ip       = yandex_vpc_address.srv_ip.external_ipv4_address[0].address
    srv_internal = yandex_compute_instance.srv.network_interface[0].ip_address
    master_ip    = yandex_compute_instance.k8s_master.network_interface[0].ip_address
    app_ip       = yandex_compute_instance.k8s_app.network_interface[0].ip_address
  })
  filename = "../ansible/inventory.ini"
}
