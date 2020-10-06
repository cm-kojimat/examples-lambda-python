data aws_iam_policy_document lambda_assume_role {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource aws_iam_role examples_lambda_python {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data aws_iam_policy_document examples_lambda_python {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "*"
    ]
  }
}

resource aws_iam_role_policy examples_lambda_python {
  role   = aws_iam_role.examples_lambda_python.id
  policy = data.aws_iam_policy_document.examples_lambda_python.json
}

data archive_file src {
  type        = "zip"
  output_path = "${path.module}/src.zip"

  dynamic source {
    for_each = fileset("${path.module}/../../src", "**/*.py")
    content {
      filename = source.value
      content  = file("${path.module}/../../src/${source.value}")
    }
  }
}

resource aws_lambda_function examples_lambda_python {
  filename = data.archive_file.src.output_path

  function_name = "examples_lambda_python_func"
  handler       = "examples_lambda_python/index.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.examples_lambda_python.arn

  source_code_hash = data.archive_file.src.output_base64sha256

  layers = [
    aws_lambda_layer_version.examples_lambda_python.id,
  ]
}

data archive_file layer {
  type = "zip"

  source_dir  = "${path.module}/../local/layer"
  output_path = "${path.module}/layer.zip"
}

resource aws_lambda_layer_version examples_lambda_python {
  layer_name       = "examples_lambda_python"
  filename         = data.archive_file.layer.output_path
  source_code_hash = data.archive_file.layer.output_base64sha256
}

