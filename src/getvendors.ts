import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { dynamodb_AddConnection, dynamodb_scanTable } from "./aws";
import { marshall, unmarshall } from "@aws-sdk/util-dynamodb";
import { PromiseResult } from "aws-sdk/lib/request";
import {
  ScanCommandOutput,
  InternalServerError,
} from "@aws-sdk/client-dynamodb";

export const handler = async (
  event: APIGatewayProxyEvent,
): Promise<APIGatewayProxyResult> => {
  const TABLE_NAME = process.env.AWS_TABLE_NAME ?? "vendors";
  const page_limt = event.queryStringParameters?.limit;
  const lastEvaluatedKey = event.queryStringParameters?.lastEvaluatedKey
    ? marshall(JSON.parse(event.queryStringParameters?.lastEvaluatedKey))
    : undefined;

  // TEST: v3
  let scanTabelGen: AsyncGenerator<ScanCommandOutput, void, unknown>;
  try {
    scanTabelGen = dynamodb_scanTable(
      TABLE_NAME,
      Number(page_limt),
      lastEvaluatedKey,
    );
  } catch (e) {
    return {
      statusCode: 500,
      headers: {
        "content-type": "text/plain; charset=utf-8",
        "Access-Control-Allow-Header": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      },
      body:
        e instanceof Error
          ? e.message
          : "dynamodb_scanTable return an unknown error",
    };
  }

  const iterator = await scanTabelGen?.next();
  if (iterator?.value) {
    return {
      statusCode: 200,
      headers: {
        "content-type": "text/plain; charset=utf-8",
        "Access-Control-Allow-Header": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      },
      body: JSON.stringify({
        Items: iterator.value.Items,
        count: iterator.value.Count,
        lastEvaluatedKey: iterator.value.LastEvaluatedKey
          ? unmarshall(iterator.value.LastEvaluatedKey)
          : null,
      }),
    };
  }

  return {
    statusCode: 200,
    headers: {
      "content-type": "text/plain; charset=utf-8",
      "Access-Control-Allow-Header": "Content-Type",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
    },
    body: JSON.stringify({
      Items: [],
      count: 0,
      lastEvaluatedKey: null,
    }),
  };
};
