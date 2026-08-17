output "certificate_arn" {
  value = aws_iot_certificate.cert.arn
}

output "certificate_pem" {
  value     = aws_iot_certificate.cert.certificate_pem
  sensitive = true
}

output "public_key" {
  value     = aws_iot_certificate.cert.public_key
  sensitive = true
}

output "private_key" {
  value     = aws_iot_certificate.cert.private_key
  sensitive = true
}

output "iot_endpoint" {
  value = data.aws_iot_endpoint.endpoint.endpoint_address
}


