resource "aws_api_gateway_rest_api" "graphql_api" {
  name        = "${var.name}_api"
  description = "${var.comment}"
}

resource "aws_api_gateway_deployment" "graphql_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.graphql_api.id}"
  stage_name  = "prod"
}


resource "aws_api_gateway_resource" "grapqhl_endpoint" {
  rest_api_id = "${aws_api_gateway_rest_api.graphql_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.graphql_api.root_resource_id}"
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "graphql_path_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.graphql_api.id}"
  resource_id   = "${aws_api_gateway_resource.grapqhl_endpoint.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "graphql_path_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.graphql_api.id}"
  resource_id             = "${aws_api_gateway_resource.grapqhl_endpoint.id}"
  http_method             = "${aws_api_gateway_method.graphql_path_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.graphql.arn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "graphql_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.graphql_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.graphql_api.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "graphql_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.graphql_api.id}"
  resource_id             = "${aws_api_gateway_rest_api.graphql_api.root_resource_id}"
  http_method             = "${aws_api_gateway_method.graphql_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.graphql.arn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
}
