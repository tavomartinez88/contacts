rm -rf ./bin &&\
mkdir ./bin &&\
GOOS=linux go build -o ./bin/create-contact-aws-lambda &&\
cd ./bin &&\
zip create-contact.zip create-contact-aws-lambda