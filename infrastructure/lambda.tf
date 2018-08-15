resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam_${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_lambda_function" "lambda" {
  function_name = "lambda_${var.name}"
  role             = "${aws_iam_role.lambda_iam.arn}"
  handler       = "server.handler"
  runtime       = "nodejs8.10"
  timeout       = "300"
  memory_size   = "256" #MB. in production, this can be up to 3GB

  filename = "../build/server.zip"
  source_code_hash = "${base64sha256(file("../build/server.zip"))}"

  tags {
    Project = "${var.name}"
  }
}


resource "aws_lambda_permission" "allow_api_to_exec_lambda" {
  statement_id  = "allow_api_to_exec_lambda"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"
  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.ssr.execution_arn}/*/*/*"

}
