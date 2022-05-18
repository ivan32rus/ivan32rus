# for k8s

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone = var.zone
}

# add default networks

resource "yandex_vpc_network" "default1" {
name = "default1"
}

resource "yandex_vpc_subnet" "k8s-network" {
  network_id = yandex_vpc_network.default1.id
  name = "k8s-network"
  zone = var.zone
  v4_cidr_blocks = ["10.1.0.0/16"]
}

resource "yandex_kubernetes_cluster" "k8s-test" {
  network_id = yandex_vpc_network.default1.id
  master {
    zonal {
      subnet_id = yandex_vpc_subnet.k8s-network.id
      zone = yandex_vpc_subnet.k8s-network.zone
      
    }
    public_ip = true
  }
   
  # service accounts

  service_account_id = var.acc_service_id
  node_service_account_id = var.acc_service_id
  
  # releases_k8s and provider
 
  release_channel         = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "node_groups" {
  cluster_id  = yandex_kubernetes_cluster.k8s-test.id
  name        = "k8s-test-group"
  version     = "1.20"

  instance_template {
    platform_id = "standard-v2"
    nat = true
    metadata = {
      ssh-keys = "test:${file(var.public_key_path)}"
    }

  #network_interface {
  #  nat = true
  #  subnet_ids = ["${yandex_vpc_subnet.k8s-network.id}"] # Используется подсеть k8s-network описанная выше
  #}

    resources {
      cores  = 4
      memory = 8
    }
  
    boot_disk {
      size = 64                
     }
   }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

}

