## NOTE: connect.ts with handler function
###run=> docker build -t connect --target connect .

#connect
FROM amazon/aws-lambda-nodejs:18 AS connect

ARG FUNCTION_DIR="var/task"

COPY package.json .

RUN npm install && npm install typescript -g

COPY . .

RUN tsc

RUN mkdir -p ${FUNCTION_DIR}

CMD ["build/connect.handler"] 

#disconnect
FROM amazon/aws-lambda-nodejs:18 AS disconnect

ARG FUNCTION_DIR="var/task"

COPY package.json .

RUN npm install && npm install typescript -g

COPY . .

RUN tsc

RUN mkdir -p ${FUNCTION_DIR}

CMD ["build/disconnect.handler"] 

#send-vendor
FROM amazon/aws-lambda-nodejs:18 AS sendvendor

ARG FUNCTION_DIR="var/task"

COPY package.json .

RUN npm install && npm install typescript -g

COPY . .

RUN tsc

RUN mkdir -p ${FUNCTION_DIR}

CMD ["build/sendvendor.handler"] 

#get-vendor
FROM amazon/aws-lambda-nodejs:18 AS getvendors

ARG FUNCTION_DIR="var/task"

COPY package.json .

RUN npm install && npm install typescript -g

COPY . .

RUN tsc

RUN mkdir -p ${FUNCTION_DIR}

CMD ["build/getvendors.handler"] 

