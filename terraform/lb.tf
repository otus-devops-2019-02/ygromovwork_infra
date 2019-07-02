resource "google_compute_instance" "reddit-lb" {
  name         = "lb"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-lb"]
  depends_on   = ["google_compute_instance.app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "projects/centos-cloud/global/images/centos-7-v20190619"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  metadata {
    #   # путь до публичного ключа
    ssh-keys = "ygromov:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    user  = "ygromov"
    agent = true

    # путь до приватного ключа
    #private_key = "${file("~/.ssh/appuser")}"
  }

  provisioner "file" {
    source      = "files/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "remote-exec" {
    script = "files/deploy_lb.sh"
  }
}

resource "google_compute_firewall" "firewall_lb" {
  name = "allow-lb-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-lb"]
}
