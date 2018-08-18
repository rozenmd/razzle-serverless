resource "aws_lambda_function" "graphql" {
  function_name    = "graphql_${var.name}"
  role             = "${aws_iam_role.lambda_iam.arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  timeout          = "45"
  memory_size      = "512"
  filename         = "../build/graphql.zip"
  source_code_hash = "${base64sha256(file("../build/graphql.zip"))}"

  tags {
    Site = "${var.name}"
  }
}


resource "aws_lambda_permission" "allow_api_to_exec_lambda_graphql" {
  statement_id  = "allow_api_to_exec_lambda_graphql"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.graphql.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.graphql_api.execution_arn}/*/*/*"
}
