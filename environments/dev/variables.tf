variable "vpc_cidr" {
  type    = string
}

variable "product_name" {
  type    = string
  default = "oodo"
}

variable "product_env" {
  type    = string
  default = "qa"
}

variable "oddo_s3_bucket_name" {
  type    = string
  default = "oddo-bucket-csv-edwin"
}
variable "oddo_artifact_bucket" {
  type    = string
  default = "oddo-bucket-artifact-edwin"
}