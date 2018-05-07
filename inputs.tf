variable "bucket" {
  description = "Name of the bucket to use to store image layers"
  default     = "sample-docker-registry-bucket"
}

variable "region" {
  description = "Region to create the AWS resources"
  default     = "sa-east-1"
}

variable "profile" {
  description = "Profile to use when provisioning AWS resources"
  default     = "beld"
}
