data "aws_iot_endpoint" "endpoint" {
  endpoint_type = "iot:Data-ATS"
}

data "http" "amazon_root_ca1" {
  url = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
}