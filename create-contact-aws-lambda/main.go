package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/tavomartinez88/contacts/create-contact-aws-lambda/handler"
)

func main() {
	lambda.Start(handler.HandleRequest)
}