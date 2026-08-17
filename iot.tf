resource "aws_iot_thing" "create_things" {
  name = "${var.name}_things"

  attributes = {
    location    = "nodered"
    environment = var.environment
    owner       = var.name
  }

}

resource "aws_iot_policy" "policy" {
  name = "${var.name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

}

resource "aws_iot_certificate" "cert" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "attach" {
  thing     = aws_iot_thing.create_things.name
  principal = aws_iot_certificate.cert.arn
}

resource "aws_iot_policy_attachment" "attach" {
  policy = aws_iot_policy.policy.name
  target = aws_iot_certificate.cert.arn
}

resource "local_file" "amazon_root_ca1" {
  content  = data.http.amazon_root_ca1.response_body
  filename = "${path.module}/certs/AmazonRootCA1.pem"
}

resource "aws_iot_topic_rule" "rule" {
    name = "${var.name}_iot_rule"
    description = "rule for firehose to s3"
    enabled = true
    sql = "SELECT * FROM alex_nodered"
    sql_version = "2016-03-23"



  
}