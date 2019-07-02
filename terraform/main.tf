terraform {
  # Версия terraform
  required_version = "0.11.11"
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "app" {
  count        = 2
  name         = "reddit-app${count.index +1}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  # metadata {
  # #   # путь до публичного ключа
  #   ssh-keys = "ygromov:${file(var.public_key_path)}"
  #   ssh-keys = "appuser1:${file(var.public_key_path)}"
  #   # ssh-keys = "appuser2:${file(var.public_key_path)}"
  # }

  connection {
    type  = "ssh"
    user  = "ygromov"
    agent = true

    # путь до приватного ключа
    #private_key = "${file("~/.ssh/appuser")}"
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    ssh-keys = "ygromov:${file(var.public_key_path)}"
  }
}

#   metadata {
#       ssh-keys = <<EOF
# ygromov:${file(var.public_key_path)}
# appuser1:${file(var.public_key_path)}
# appuser2:${file(var.public_key_path)}
#       EOF
#   }

# }

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
