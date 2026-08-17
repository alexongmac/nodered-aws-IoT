variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "the name of the resource"
  type        = string
  default     = "alex"
}

variable "environment" {
  description = "the environment to deploy to"
  type        = string
  default     = "dev"
}