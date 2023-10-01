variable "user_uuid" {
  description = "The UUID of the user"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "index_html_filepath" {
  type = string
}

variable "error_html_filepath" {
  type = string
}