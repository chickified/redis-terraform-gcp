
variable "region_name" {
  default = "asia-southeast1"
}

variable "project" {
  default = "central-beach-194106"
}

variable "gcp_credentials" {
  default = "credentials/gcp_credentials.json"
}

variable "aws_credentials" {
  default = "credentials/aws_credentials"
}

variable "yourname" {
  default = ""
}

# dev or poc
variable "env" {
  default = "poc"
}

variable "allIPAddresses"{
  default = "0.0.0.0/0"
}

variable "private_subnet" {
  default = "192.168.1.0/24"
}

variable "dns_zone_dns_name" {
  default = ""
}

variable "RS_release" {
  default="https://s3.amazonaws.com/redis-enterprise-software-downloads/6.2.8/redislabs-6.2.8-39-bionic-amd64.tar"
}

variable "RS_admin" {
  default = "admin@redis.com"
}

variable "route53zoneid"{
  default = ""
}

variable "gcp_instance_type"{
  default = "e2-standard-2" # 2 vCPUs, 8GB Memory
  # default = "n1-standard-16" # 16 vCPUs, 60GB Memory
}

variable "clustersize" {
  # You should use 3 for some more realistic installation
  default = "3"
}
