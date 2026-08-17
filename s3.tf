resource "aws_s3_bucket" "iot_data" {
  bucket        = "${var.name}-${var.environment}-iot-data"
  force_destroy = true
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.name}-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "firehose_s3_policy" {
  name = "${var.name}-firehose-s3-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject",
      ]
      Effect = "Allow"
      Resource = [
        aws_s3_bucket.iot_data.arn,
        "${aws_s3_bucket.iot_data.arn}/*",
      ]
    }]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "iot_to_s3" {
  name        = "${var.name}-iot-to-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.iot_data.arn
    prefix             = "alex_nodered_firehose/"
    buffering_interval = 60
    buffering_size     = 1
  }
}

resource "aws_iam_role" "iot_firehose_role" {
  name = "${var.name}-iot-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "iot.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "iot_firehose_policy" {
  name = "${var.name}-iot-firehose-policy"
  role = aws_iam_role.iot_firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["firehose:PutRecord"]
      Effect   = "Allow"
      Resource = aws_kinesis_firehose_delivery_stream.iot_to_s3.arn
    }]
  })
}

resource "aws_iot_topic_rule" "to_firehose" {
  name        = "${replace(var.name, "-", "_")}_to_firehose"
  enabled     = true
  sql         = "SELECT * FROM 'alex_nodered'"
  sql_version = "2016-03-23"

  firehose {
    delivery_stream_name = aws_kinesis_firehose_delivery_stream.iot_to_s3.name
    role_arn             = aws_iam_role.iot_firehose_role.arn
  }
}
