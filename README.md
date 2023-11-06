# Flight_Prediction_Project

This project, drawing from the [Machine Learning Zoomcamp](https://github.com/DataTalksClub/machine-learning-zoomcamp/tree/master) course and utilizing the [Flight Delay](https://www.kaggle.com/datasets/arvindnagaonkar/flight-delay) dataset from Kaggle, aims to create a real-time machine learning system for predicting flight durations. It leverages Azure Event Hubs for data ingestion and output, providing predictions that can support both business decision-making and passenger experience. Predicted flight durations are continually updated and can be used for optimizing airline operations, enabling customer applications for real-time information, and aiding various industry decision-making processes, thereby enhancing operational efficiency and passenger satisfaction within the aviation sector


## Table of Contents
- [Problem Statement](#problem-statement)
- [Tools Used](#tools-used)
- [Project Flow](#project-flow)
  - [1.Download Data and Train Model](#1-download-data-and-train-model)
  - [2.Generate Event to Azure Event Hub](#2-generate-event-to-azure-evenet-hub)
  - [3.Receive and Send Event to Another Event Hub](#3-receive-and-send-event-to-another-event-hub)
  - [4.Receive Predict Event](#4-receive-predict-event)
- [Reproducibility](#reproducibility)
- [Further Improvements](#further-improvements)

## Problem Statement
When booking a flight, passengers often receive estimated flight durations that may not accurately reflect real-world conditions. Factors such as departure and arrival delays can significantly impact the actual flight duration, leading to uncertainty and inconvenience for travelers. To address this issue and provide a more accurate and reliable flight duration timeline for customers, this project seeks to employ machine learning techniques. By training a machine learning model on historical flight delay data, this project aim to develop a predictive system capable of predicting flight durations in real-time. This predictive model will consider various factors, including weather, aircraft type, historical performance, and real-time data feeds, to provide up-to-date and more precise flight duration estimates. Additionally, this predictive system can assist airlines in optimizing their operations, resource allocation, and scheduling, contributing to improved operational efficiency and passenger satisfaction within the aviation industry.

## Tools Used

This project used the tool below.

- Infrastructure Setup: Terraform (for provisioning and managing infrastructure)
- Containerization: Docker and Docker-compose (for containerized deployment and management)
- Cloud Storage: Azure Blob Storage (for data storage)
- Reproducibility: Makefile (for ease of project reproducibility)
- Machine Leraning: Scikit-learn (for modle prediction)

## Project Flow

![Project Flow](/image/other/projectflow.jpeg)

### 1. Download Data and Train Model

We begin by acquiring the Flight Delay dataset from Kaggle and conduct data exploration to gain insights. We experiment with machine learning models, focusing on the simplicity and accuracy of Linear Regression. Following model training, we generate a model artifact, including the model itself and a dict vectorizer for future production deployment. We also create sample event data to simulate real-time flight data for the next step.

### 2. Generate Event to Azure Evenet hub

Using the sample data generated in step 1, we send events to an Azure Event Hub to simulate real-time data transmission.

### 3. Receive and Send Event to Another Event Hub

A Python script is designed to listen to an Azure Event Hub, fetching incoming events. The script utilizes the trained model from step 1 to make predictions based on received data. Checkpoint events are created and stored in Azure Blob Storage to prevent event duplication. Once the data is processed, the predicted events are pushed into another Azure Event Hub.

### 4. Receive Predict Event

Another Python script is developed to monitor the Azure Event Hub containing the predicted events. This output can serve as an API response or be used in customer-facing applications and for critical business decisions.

## Reproducibility

`Prerequisite`:
To reproduce this project you would need [Azure Account](https://azure.microsoft.com/en-us) account

You also need below package

1. [Makefile](https://pypi.org/project/make/) `pip install  make`
2. [Azure CLI]https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
3. [Terraform](https://developer.hashicorp.com/terraform/downloads)
4. [Docker](https://www.docker.com/)
5. [Docker Compose](https://docs.docker.com/compose/)

You will also need [package](requirement.txt) to train the model you can run
```
make prerequisite
```
to install the package required.

Once all package is installed please follow the step in [Reproducre](/other) to re-create the project

## Further Improvements
Deploy the consumer docker as a function app

Improve prediction accuracy
