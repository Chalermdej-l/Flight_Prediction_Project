include .env

# docker
dockercreate:
	docker build -f dockerfile/producer.dockerfile -t producer .
	docker build -f dockerfile/consumer.dockerfile -t consumer .
	docker build -f dockerfile/predict.dockerfile -t predict .

dockerproduce:
	docker-compose --profile producer up --detach 

dockerconsumer:
	docker-compose --profile consumer up --detach 

dockerpredict:
	docker-compose --profile predict up --detach 

dockerup:
	docker-compose --profile producer up --detach 
	docker-compose --profile consumer up --detach 
	docker-compose --profile predict up --detach 

dockerdown:
	docker-compose  --profile producer stop
	docker-compose  --profile consumer stop
	docker-compose  --profile predict stop

	docker-compose  --profile producer down
	docker-compose  --profile consumer down
	docker-compose  --profile predict down
	
dockerprune:
	docker system prune --force

dockerdeploy:
	az login
	az acr login --name ${CONTAINER_NAME}
	docker tag  ${CONTAINER_IMAGE} ${CONTAINER_NAME}.azurecr.io/${CONTAINER_IMAGE}:consume
	docker push ${CONTAINER_NAME}.azurecr.io/${CONTAINER_IMAGE}:consume

# Terraform
infra-setup:
	terraform -chdir=./infra init 
	terraform -chdir=./infra plan -var-file=variables.tfvars

infra-down:
	terraform -chdir=./infra destroy -var-file=variables.tfvars -auto-approve

infra-create:
	terraform -chdir=./infra apply -var-file=variables.tfvars -auto-approve

infra-resouce:
	terraform -chdir=./infra apply -var-file=variables.tfvars -target=module.blob -target=module.resourcegroup -target=module.eventhub -target=module.dockerregis -auto-approve

infra-function:
	terraform -chdir=./infra apply -var-file=variables.tfvars -target=module.function -auto-approve

infra-output:
	# EVENT_HUB_CONNECTION_PRODUCER_SEND_KEY
	terraform -chdir=./infra output  -raw eventhub_producer_send_auth_rule
    
	echo
	#------------------
	# EVENT_HUB_CONNECTION_PRODUCER_LISTEN_KEY
	terraform -chdir=./infra output  -raw eventhub_producer_listen_auth_rule

	echo
	#------------------
	# EVENT_HUB_CONNECTION_CONSUMER_LISTEN_KEY
	terraform -chdir=./infra output  -raw eventhub_consumer_listen_auth_rule

	echo
	#------------------
	# EVENT_HUB_CONNECTION_CONSUMER_SEND_KEY
	terraform -chdir=./infra output  -raw eventhub_consumer_send_auth_rule

	echo
	#------------------
	# BLOB_STORAGE_CONNECTION_PRODUCER
	terraform -chdir=./infra output  -raw consumer_connection_string

	echo
	#------------------
	# BLOB_STORAGE_CONNECTION_CONSUMER
	terraform -chdir=./infra output  -raw predict_connection_string
	
	echo
	#------------------

infra-config:
	az login

envupdate:
	python code\flow\envupdate.py

trainmodel:
	python code\flow\train.py

gensample:
	python code\flow\gensampledata.py

prerequisite:
	pip install -r  requirement.txt