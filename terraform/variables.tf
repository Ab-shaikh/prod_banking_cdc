variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "m7i-flex.large"
}

variable "key_pair_name" {
  description = "Name of existing EC2 key pair for SSH access"
  type        = string
  default     = "raisa" # APNA KEY PAIR NAAM DALEIN
}

variable "my_ip" {
  description = "Open to anywhere for Lab Testing"
  type        = string
  default     = "0.0.0.0/0" # FIX: Ab light jane par issue nahi hoga
}

variable "iam_role_name" {
  description = "Existing IAM role name to attach to EC2"
  type        = string
  default     = "s3_access_ec2"
}

variable "snowflake_account" {
  description = "Snowflake Account ID"
  type        = string
}

variable "snowflake_user" {
  description = "Snowflake Username"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflake Password"
  type        = string
  sensitive   = true  # Yeh console logs mein password hide kar dega
}