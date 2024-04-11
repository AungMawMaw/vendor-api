# arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

#create iam policy for lambda
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# iam role with policy for lambda
resource "aws_iam_role" "lambda_main" {
  name               = "${var.app_name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# adding lambdaexecutionrole to lambda
resource "aws_iam_role_policy_attachment" "attach_exec_role" {
  role = aws_iam_role.lambda_main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#create iampolicy
data "aws_iam_policy_document" "lambda_websocket" {
   statement {
       actions = [
      "execute-api:ManageConnects",
      "dynamodb:DescribeTable",
      "dynamodb:Scan",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttrivutes",
       ]
       resources = [
           "arn:aws:sqs:${var.aws_region}:${local.account_id}:${var.sqs_queue_name}",
           "arn:aws:dynamodb:${var.aws_region}:${local.account_id}:table/${var.websocket_table_name}",
           "arn:aws:dynamodb:${var.aws_region}:${local.account_id}:table/${var.vendor_table_name}",
       ]
   }

   statement {
       actions = [
           "s3:ListBucket",
       ]
       resources = [
           "arn:aws:s3:::${var.s3_bucket_name}",
       ]
       condition {
           test = "StringLike"
           variable = "s3:prefix"
           values = [
               "",
               "home/",
               "home/&{aws:username}/",
           ]
       }
   }

   statement {
       actions = [
           "s3:*",
       ]
       resources = [
           "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}",
           "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}/*",
       ]
   }
}

resource "aws_iam_policy" "example" {
   name = "example_policy"
   path = "/"
   policy = "${data.aws_iam_policy_document.example.json}"
}


