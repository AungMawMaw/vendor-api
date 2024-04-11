variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "vendor-api"
}

variable "websocket_table_name" {
  type        = string
  description = "Name of the web socket connection table in dynamo db"
  default     = "websocket-connections"
}

variable "sqs_queue_name" {
  type        = string
  description = "Queue name"
  default     = "vendor-sqs"
}

variable "sqs_queue_url" {
  # type        = string
  description = "Queue url"
  default     = "https://sqs.ap-southeast-1.amazonaws.com/688217156264/vendor_sqs"
}

variable "api_gateway_stage_name" {
  type    = string
  default = "primary"
}

variable "vendor_table_name" {
  description = "Table name for dynamodb vendors"
  default     = "vendors"
}

variable "image_tag" {}

variable "aws_region" {}
