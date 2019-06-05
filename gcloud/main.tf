// TODO: delete kube ingress before destroy to make sure the IP is realeased
variable "region" {
  type    = "string"
  default = "europe-west3"
}

variable "cluster-name" {
  type    = "string"
  default = "kitc-cluster"
}

variable "project-name" {
  type    = "string"
  default = "om-front-end"
}

provider "google-beta" {
  project = "${var.project-name}"
  region  = "${var.region}"
}

resource "google_container_node_pool" "kitc-np" {
  project    = "${var.project-name}"
  name       = "kitc-node-pool"
  cluster    = "${google_container_cluster.kitc-cluster.name}"
  region     = "${var.region}"
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type    = "n1-standard-2"
    disk_type       = "pd-ssd"
    disk_size_gb    = 10
    oauth_scopes    = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels {
      type = "kitc"
    }
  }
}

resource "google_container_cluster" "kitc-cluster" {
  project                  = "${var.project-name}"
  name                     = "${var.cluster-name}"
  network                  = "gc-om-fe-lan"
  subnetwork               = "gc-om-fe-lan"
  initial_node_count       = 1
  remove_default_node_pool = true
  region                   = "${var.region}"
  additional_zones         = [
    "europe-west3-a",
    "europe-west3-b",
  ]

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials --region=${var.region} ${google_container_cluster.kitc-cluster.name}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ./"
  }
}
