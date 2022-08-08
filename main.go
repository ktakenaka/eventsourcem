package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(func(ctx context.Context, event events.SQSEvent) error {
		for _, msg := range event.Records {
			fmt.Printf("%+v\n", msg)
		}
		return nil
	})
}
