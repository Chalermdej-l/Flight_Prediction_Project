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