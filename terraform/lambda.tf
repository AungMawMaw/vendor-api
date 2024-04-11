resource "aws_lambda_function" "connect" {
  function_name = "${var.app_name}-connect"
  role          = aws_iam_role.lambda_main.arn
  image_uri     = "${local.account_id}.dkr.erc.${var.aws_region}.amazonaws.com./connect:${var.image_tag}"
  package_type  = "Image"
  timeout       = 30
  environment {
    variables = {
      AWS_WEBSOCKET_TABLE_NAME = "${var.websocket_table_name}"
    }
  }
}
resource "aws_lambda_permission" "connect_permision" {
  function_name = aws_lambda_function.connect.function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  # source_arn = "" #TODO: apigateway
}
#### end of lambda connect

resource "aws_lambda_function" "disconnect" {
  function_name = "${var.app_name}-disconnect"
  role          = aws_iam_role.lambda_main.arn
  image_uri     = "${local.account_id}.dkr.erc.${var.aws_region}.amazonaws.com./disconnect:${var.image_tag}"
  package_type  = "Image"
  timeout       = 30
  environment {
    variables = {
      AWS_WEBSOCKET_TABLE_NAME = "${var.websocket_table_name}"
    }
  }
}
resource "aws_lambda_permission" "disconnect_permision" {
  function_name = aws_lambda_function.disconnect.function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  # source_arn = "" #TODO: apigateway
}
#### end of lambda disconnect

resource "aws_lambda_function" "sendvendor" {
  function_name = "${var.app_name}-sendvendor"
  role          = aws_iam_role.lambda_main.arn
  image_uri     = "${local.account_id}.dkr.erc.${var.aws_region}.amazonaws.com./sendvendor:${var.image_tag}"
  package_type  = "Image"
  timeout       = 30
  environment {
    variables = {
      AWS_WEBSOCKET_TABLE_NAME = "${var.websocket_table_name}"
      AWS_SQS_QUEUE_URL        = "${var.sqs_queue_url}"
      # AWS_WEBSOCKET_URL        = ""
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = "arn.aws.sqs:${var.aws_region}:${local.account_id}:${var.sqs_queue_name}"
  function_name    = aws_lambda_function.sendvendor.arn
}

resource "aws_lambda_permission" "sendvendor_permision" {
  statement_id = "AllowExecutionFromSQS"
  source_arn   = "arn.aws.sqs:${var.aws_region}:${local.account_id}:${var.sqs_queue_name}"

  function_name = aws_lambda_function.sendvendor.function_name
  principal     = "sqs.amazonaws.com"
  action        = "lambda:InvokeFunction"
  # source_arn = "" #TODO: apigateway
}
#### end of lambda sendvendor

resource "aws_lambda_function" "getvendor" {
  function_name = "${var.app_name}-getvendor"
  role          = aws_iam_role.lambda_main.arn
  image_uri     = "${local.account_id}.dkr.erc.${var.aws_region}.amazonaws.com./getvendor:${var.image_tag}"
  package_type  = "Image"
  timeout       = 30
  environment {
    variables = {
      AWS_TABLE_NAME = "${var.vendor_table_name}"
    }
  }
}
resource "aws_lambda_permission" "getvendor_permision" {
  function_name = aws_lambda_function.getvendor.function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  # source_arn = "" #TODO: apigateway
}

#### end of lambda getvendor




#NOTE: uncomment => main.yml> ecr blah blah and git upload


