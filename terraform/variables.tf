variable "aws_region" {
  description = "The AWS region to be used"
  default     = "eu-west-2"
}

variable "trusted_ip_poise" {
  description = "Trusted Ip addresses from poise"
  type        = list(string)
  default = [
    "52.56.62.217/32"
  ]
}

# PA Ips are not configured as still waiting furhter information/decission is pendig 
#variable "trusted_PA_addresses" {
#  description = "PA public IP addresses"
#  type        = list(string)
#  default = [
#    "0.0.0.0/0"
#  ]
#}

variable "trusted_ip_bae" {
  description = "Trusted Ip addresses from BAE"
  type        = list(string)
  default = [
    "20.133.14.254/32"
  ]
}

variable "trusted_ip_tooling" {
  description = "Trusted Ip addresses from Tooling account"
  type        = list(string)
  default = [
    "172.28.4.0/24"
  ]
}

variable "build_tag" {
  default = "Terraform"
}

variable "key_name" {
  description = "Key for server access"
  default     = "inboundproxy"
}

variable "vpc_id" {
  description = "The aws vpc id"
  default     = "vpc-02e8e1c8fecb5cf38"
}

variable "inboundproxy_instance_type" {
  description = "Instance type for the vault server"
  default     = "t2.micro"
}

variable "vm_disable_api_termination" {
  description = "api termination"
  default     = false
}

variable "vpc_zone" {
  type = list(string)
  default = [
    "subnet-0ed6c5d1beb5d13be",
    "subnet-0be98bb1d2e53d51f"
  ]
}

# Variables for the Directory Service 

variable "domain_name" {
  description = "Domain name for the instance"
  default = "ib-proxy.np.ncds.uk"
}

variable "dir_domain_name" {
  description = "Directory service domain name for AD"
  default = "np.ncds.uk"
}

variable "dir_username" {
  description ="AD user to join domain"
  default ="SA_DOMAIN_JOIN"
}

variable "dir_password" {
  description = "AD password to join domain"
  default = "c74Z59axANRw=pfRoO#hUoYt"
}

#variable for the KMS

variable "kms_arn" {
  description = "KMS keys"
  default = "arn:aws:kms:eu-west-2:260563756810:key/549e8144-1e50-4fd5-898b-c576a2f370e5"
}


