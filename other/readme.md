
# Table of Contents

1. [Clone the Project and Download Data](#1-clone-the-project-and-download-data)
2. [Train Model and Infrastructure Initialization](#2-train-model-and-infrastructure-initialization)
3. [Docker Create and Run](#3-docker-create-and-run)
4. [Monitor the Event](#4-monitor-the-event)
5. [Clean up](#5-clean-up)

## 1. Clone the Project and Download Data

First, clone the project and navigate to the cloned directory:

```
git clone https://github.com/Chalermdej-l/Flight_Prediction_Project.git
cd Flight_Prediction_Project
```
Run the following command to install the package to install and train model:

```
make prerequisite
```

Download the data from [Flight Delay](https://www.kaggle.com/datasets/arvindnagaonkar/flight-delay)

We will use the `features_added.parquet` file once download place the parquet to the [data](/data) folder

## 2. Train Model and Infrastructure Initialization

After data is download and place in the data folder run the following command to train the model

```
make trainmodel
```
The script will load in the model and train the model and eveulate the model

![](/image/setup/1.png)

and output the model to [artifact](/artifact) folder

Next run the below command the generate a sample event data we will use this dat in the future step 

```
make gensample
```

Next we will setup our infrastructure run the below command to login to azure

```
make infra-config
```

Then run to setup the infrastructure
```
make infra-setup
```
![](/image/setup/2.png)

The command will plan the resoure to create
Run below command to create the resource

```
make infra-create
```
![](/image/setup/3.png)

The command will create Azure Event hub space and 2 event hub for producer and consumer
![](/image/setup/4.png)

![](/image/setup/5.png)

and create 2 blob storage for checkpoint
![](/image/setup/6.png)

After all resource create run below command to update the [.env](.env) file to used in docker creation credential
```
make envupdate
```
![](/image/setup/7.png)
## 3. Docker Create and Run

Next we will create the docker image to used in our service run the below command 

```
make dockercreate
```
![](/image/setup/8.png)

This will create 3 image

Run the below command to start the image.
```
make dockerup
```
![](/image/setup/9.png)

This command will start up our image along with the necessary credential to run the image
![](/image/setup/10.png)

## 4. Monitor the Event
After the all image run the event will be send to the Azure Event Hub from the producer image

![](/image/setup/11.png)

![](/image/setup/12.png)
Once the image is push to the Event Hub this will take a minute or two for the event to be consume by the consumer image

![](/image/setup/14.png)

The consumer image will recive the data and create a prediction and output to the consumer event hub
![](/image/setup/13.png)

Then the predict image will receive the data from the consuemr image with the predict result and other meta data like modle version and event date
![](/image/setup/15.png)

## 5. Clean up
After finish with the reproduce you can run the below command to stop and delete the docker image

```
make dockerdown
```
![](/image/setup/16.png)
and run the below command to delete all service create by terraform
```
make infradown
```
![](/image/setup/17.png)
