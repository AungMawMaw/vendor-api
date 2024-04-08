import { dynamodb_AddConnection } from "./aws";

const exec = async () => {
  const res = await dynamodb_AddConnection("websocket-connection", "123");
  console.log(res);
};
exec();
