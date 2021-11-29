provider "google" {
  project     = var.project
  region      = var.region_name
  credentials = var.gcp_credentials
}

provider "aws"{
  region = "ap-southeast-1"
  shared_credentials_file = var.aws_credentials
  profile = "default"
}
######################################################################


#output "rs_ui_ip" {
#  value = flatten([ "https://${aws_route53_record.node1Arecord.name}:8443" , 
#                    "https://${aws_route53_record.node2Arecord.name}:8443" ,
#                    "https://${aws_route53_record.node3Arecord.name}:8443" ])
#}

output "rs_cluster_dns" {
	value = "rscluster.${var.dns_zone_dns_name}"
}

output "Node1_IP" {
  value = flatten([flatten([aws_route53_record.node1Arecord.name, google_compute_instance.node1.network_interface.0.access_config.0.nat_ip])])
}

output "NodeX_IPs"{
  value = flatten([aws_route53_record.nodeXArecord.*.name, google_compute_instance.nodeX.*.network_interface.0.access_config.0.nat_ip ])
}

output "memtier_benmark_instance"{
  value = "${aws_route53_record.memtierArecord.name} : ${google_compute_instance.memtier_instance.network_interface.0.access_config.0.nat_ip}"
}

output "admin_username" {
  value = var.RS_admin
}
output "admin_password" {
  value = random_password.password.result
  sensitive = true
}
