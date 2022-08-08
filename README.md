# Setup
```
 $ cat ~/.aws/config
...
[profile sample]
aws_access_key_id=accesskey
aws_secret_access_key=secret
region=ap-northeast-1

$ cat .envrc
export AWS_PROFILE=sample
```

*In this repository, we don't do persistence of localstack data to start it fresh everytime.

# Demo
1. Create q queue
```
$ aws sqs create-queue --queue-name sample --endpoint-url=http://localhost:4566
```

2. Create or Update function in Lambda
```
$ GOOS=linux CGO_ENABLED=0 go build ./main.go && zip main.zip main
$ aws lambda create-function \
  --endpoint-url=http://localhost:4566 \
  --function-name sample \
  --handler main \
  --runtime go1.x \
  --zip-file fileb://main.zip \
  --role arn:aws:iam::000000000000:role/sample
```

3. Confirm if the function is created
```
$ aws lambda list-functions --endpoint-url http://localhost:4566
```

4. Create SQS hook to the function
```
$ aws lambda create-event-source-mapping \
  --endpoint-url=http://localhost:4566 \
  --function-name sample \
  --event-source-arn arn:aws:sqs:ap-northeast-1:000000000000:sample
```

5. Confirm if the hook is registered
```
$ aws lambda list-event-source-mappings --endpoint-url http://localhost:4566
```

6. Send a message to SQS
```
$ aws sqs send-message \
  --queue-url http://localhost:4566/queue/sample \
  --message-body '{"name":"hello"}' \
  --endpoint-url=http://localhost:4566
```
