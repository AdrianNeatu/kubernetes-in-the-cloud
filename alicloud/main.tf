provider "alicloud" {
  region     = "eu-central-1"
}

data "alicloud_instance_types" "default" {
  availability_zone = "eu-central-1a"
  cpu_core_count = 1
  memory_size = 2
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  name = "test-cluster"
  availability_zone = "eu-central-1a"
  new_nat_gateway = true
  worker_instance_types = ["${data.alicloud_instance_types.default.instance_types.0.id}"]
  worker_numbers = [2]
  password = "Yourpassword1234"
  pod_cidr = "172.20.0.0/16"
  service_cidr = "172.21.0.0/20"
  install_cloud_monitor = true
  slb_internet_enabled = true
  worker_disk_category  = "cloud_efficiency"
}
