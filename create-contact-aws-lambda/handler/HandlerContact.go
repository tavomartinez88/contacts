package handler

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/tavomartinez88/contacts/create-contact-aws-lambda/structs"
	"os"
	"time"
)

const (
	StatusRequest = "CREATED"
	TableName = "ContactGolangGm"
)

func HandleRequest(ctx context.Context, request structs.ContactRequest) (string, error) {
	timeProcess := time.Now().Format("2006-01-02 15:04:05")
	request.Status = StatusRequest
	request.Created = timeProcess
	request.Updated = timeProcess

	insertContact(request)

	return fmt.Sprintf("%v\n", "Contact : "+ request.FirstName + "-" + request.LastName + " added."), nil
}

func insertContact(request structs.ContactRequest)  {
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	client := dynamodb.New(sess)
	item, err := dynamodbattribute.MarshalMap(request)

	if err != nil {
		fmt.Println("Got error marshalling new contact item:")
		fmt.Println(err.Error())
		os.Exit(1)
	}

	input := &dynamodb.PutItemInput{Item: item, TableName: aws.String(TableName)}

	_, err = client.PutItem(input)

	if err != nil {
		fmt.Println("Got error calling PutItem:")
		fmt.Println(err.Error())
		os.Exit(1)
	}
}

