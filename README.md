# vendor-api

docker build -t disconnect --target disconnect .

docker run -v $HOME/.aws:/root/.aws:ro \
 -e AWS_ACCESS_KEY_ID \
 -e AWS_CA_BUNDLE \
 -e AWS_CLI_FILE_ENCODING \
 -e AWS_CONFIG_FILE \
 -e AWS_DEFAULT_OUTPUT \
 -e AWS_DEFAULT_REGION \
 -e AWS_PAGER \
 -e AWS_PROFILE \
 -e AWS_ROLE_SESSION_NAME \
 -e AWS_SECRET_ACCESS_KEY \
 -e AWS_SESSION_TOKEN \
 -e AWS_SHARED_CREDENTIALS_FILE \
 -e AWS_STS_REGION_ENDPOINTS \
 -p 9001:8080 connect:latest

curl -XPOST "http://localhost:9001/2015-03-31/functions/function/invocations" \
 -d '{"requestContext":{"connectionId":"1234"}}'

after all done
install wscat
npm install -g wscat
