
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
Run the following command to install the package to install and train the model:

```
make prerequisite
```

Download the data from [Flight Delay](https://www.kaggle.com/datasets/arvindnagaonkar/flight-delay)

We will use the `features_added.parquet` file once download place the parquet to the [data](/data) folder

## 2. Train Model and Infrastructure Initialization

After data is downloaded and placed in the data folder run the following command to train the model

```
make trainmodel
```
The script will load in the model train the model and evaluate the model

![](/image/setup/1.png)

and output the model to [artifact](/artifact) folder

Next, run the below command the generate a sample event data we will use this data in the future step 

```
make gensample
```

Next, we will set up our infrastructure and run the below command to log in to Azure

```
make infra-config
```

Then run to set the infrastructure
```
make infra-setup
```
![](/image/setup/2.png)

The command will plan the resources to create
Run the below command to create the resource

```
make infra-create
```
![](/image/setup/3.png)

The command will create Azure Event hub space and 2 event hubs for producer and consumer
![](/image/setup/4.png)

![](/image/setup/5.png)

and create 2 blob storage for checkpoint
![](/image/setup/6.png)

After all resources are created run the below command to update the [.env](/.env) file to be used in the docker creation credential

Please note if you change any variable here you will also have to change in [infra](infra/variables.tfvars)

```
make envupdate
```
![](/image/setup/7.png)
## 3. Docker Create and Run

Next, we will create the docker image to be used in our service and run the below command 

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

This command will start up our image along with the necessary credentials to run the image
![](/image/setup/10.png)

## 4. Monitor the Event
After the image run the event will be sent to the Azure Event Hub from the producer image

![](/image/setup/11.png)

![](/image/setup/12.png)
Once the image is pushed to the Event Hub this will take a minute or two for the event to be consumed by the consumer image

![](/image/setup/14.png)

The consumer image will receive the data and create a prediction and output to the consumer event hub
![](/image/setup/13.png)

Then the predicted image will receive the data from the consumer image with the predicted result and other metadata like model version and event date
![](/image/setup/15.png)

## 5. Clean up
After finishing with the reproduction you can run the below command to stop and delete the docker image

```
make dockerdown
```
![](/image/setup/16.png)
and run the below command to delete all services create by Terraform
```
make infradown
```
![](/image/setup/17.png)
