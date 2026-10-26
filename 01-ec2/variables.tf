variable "ssh_allowed_cidr" {
  description = "Public IPv4 CIDR allowed to connect to the instance over SSH, for example your-ip/32."
  type        = string
}

variable "ec2_key_pair_name" {
  description = "Existing EC2 key-pair name in the configured AWS Region."
  type        = string
}
