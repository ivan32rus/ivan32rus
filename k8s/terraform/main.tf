# for k8s
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone = var.zone
}

resource "yandex_vpc_network" "default1" {
  name = "default1"
}

resource "yandex_vpc_subnet" "k8s-network" {
  network_id = yandex_vpc_network.default1.id
  name = "k8s-network"
  zone = var.zone
  v4_cidr_blocks = ["10.1.0.0/16"]
}


resource "yandex_iam_service_account" "k8s-test" {
  name = "k8s-test"
  description = "editor"
}

#resource "yandex_resourcemanager_folder_iam_binding" "editor" {
#  # Сервисному аккаунту назначается роль "editor".
#  folder_id = var.folder_id
#  role = "editor"
#  members = [
#             "serviceAccount:${yandex_iam_service_account.k8s-test.id}"
#  ]
#}

#resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
#  # Сервисному аккаунту назначается роль "container-registry.images.puller".
#  folder_id = var.folder_id
#  role = "container-registry.images.puller"
#  members =  [
#              "serviceAccount:${yandex_iam_service_account.k8s-test.id}"
#  ]
#}

resource "yandex_kubernetes_cluster" "k8s-test" {
  network_id = yandex_vpc_network.default1.id
  master {
    zonal {
      subnet_id = yandex_vpc_subnet.k8s-network.id
      zone = yandex_vpc_subnet.k8s-network.zone

    }
    public_ip = true
  }

  #service_account_id = test
  #node_service_account_id = test
  service_account_id = yandex_iam_service_account.k8s-test.id
  node_service_account_id = yandex_iam_service_account.k8s-test.id
    depends_on = [
     # yandex_resourcemanager_folder_iam_binding.editor,
     # yandex_resourcemanager_folder_iam_binding.images-puller
     ]
}

# Image whis a packer builders

resource "yandex_kubernetes_node_group" "node_groups" {
  cluster_id  = yandex_kubernetes_cluster.k8s-test.id
  name        = "k8s-test-group"
  version     = "1.20"

  instance_template {
    platform_id = "standard-v2"
#    nat = true
    metadata = {
      ssh-keys = "test:${file(var.public_key_path)}"
    }

  network_interface {
    nat = true
    subnet_ids = ["${yandex_vpc_subnet.k8s-network.id}"] # Используется подсеть k8s-network описанная выше
  }

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
