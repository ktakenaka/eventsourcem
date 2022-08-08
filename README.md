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

2. Make zip
```
$ GOOS=linux CGO_ENABLED=0 go build ./main.go && zip main.zip main
```

3. Create a function in Lambda and confirm if the function is created
```
$ aws lambda create-function \
  --endpoint-url=http://localhost:4566 \
  --function-name sample \
  --handler main \
  --runtime go1.x \
  --zip-file fileb://main.zip \
  --role arn:aws:iam::000000000000:role/sample
$ aws lambda list-functions --endpoint-url http://localhost:4566
```

4. Create a SQS hook with the function and confirm if the hook is registered
```
$ aws lambda create-event-source-mapping \
  --endpoint-url=http://localhost:4566 \
  --function-name sample \
  --event-source-arn arn:aws:sqs:ap-northeast-1:000000000000:sample
$ aws lambda list-event-source-mappings --endpoint-url http://localhost:4566
```

5. Send a message to SQS
```
$ aws sqs send-message \
  --queue-url http://localhost:4566/queue/sample \
  --message-body '{"name":"hello"}' \
  --endpoint-url=http://localhost:4566
```
