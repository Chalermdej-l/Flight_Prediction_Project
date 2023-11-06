import asyncio
import pickle
import json
import datetime
import functools
import os 
from azure.eventhub import EventData
from azure.eventhub.aio import EventHubProducerClient
from azure.eventhub.aio import EventHubConsumerClient
from azure.eventhub.extensions.checkpointstoreblobaio import (
    BlobCheckpointStore,
)

# credential for connect to producer
EVENT_HUB_CONNECTION_STR = os.getenv("EVENT_HUB_CONNECTION_STR") 
EVENT_HUB_NAME = os.getenv("EVENT_HUB_NAME")
EVENT_HUB_CONSUMER_GROUP_EVENT = os.getenv("EVENT_HUB_CONSUMER_GROUP_EVENT")

# credential for connect to consumer from producer
BLOB_STORAGE_CONNECTION_STRING = os.getenv("BLOB_STORAGE_CONNECTION_STRING")
BLOB_CONTAINER_NAME = os.getenv("BLOB_CONTAINER_NAME")

# credential for produce event to another steam
EVENT_HUB_CONNECTION_STR_OUT = os.getenv("EVENT_HUB_CONNECTION_STR_OUT")
EVENT_HUB_NAME_OUT = os.getenv("EVENT_HUB_NAME_OUT")

def getmodel():
    model = pickle.load(open('artifact/model.sav','rb'))
    dv = pickle.load(open('artifact/dv.sav','rb'))

    return model,dv

def predict(data,dv,model):
    scale_data = dv.transform(data)
    pred = model.predict(scale_data)

    return pred

def constructoutput(pred,data,model):    
    out_respond = {
        'model': model.__hash__(),
        'eventdate': datetime.datetime.today().strftime('%Y-%m-%d'),
        'result' :{
            'flightdate':data['FlightDate'],
            'flightid':data['FlightID'],
            'airlinenetwork':data['Marketing_Airline_Network'],
            'origin':data['OriginCityName'],
            'dest':data['DestCityName'],
            'predictduration':pred
        }
    }
    return json.dumps(out_respond)

async def outputresult(result):
            
    producer = EventHubProducerClient.from_connection_string(
        conn_str=EVENT_HUB_CONNECTION_STR_OUT, eventhub_name=EVENT_HUB_NAME_OUT
    )

    # result = EventData(result)
    # await producer.send_event(result)

    event_data_batch = await producer.create_batch()    

    event_data_batch.add(EventData(json.dumps(result)))

    await producer.send_batch(event_data_batch)


async def on_event(partition_context, events, model, dv):

    for event in events:
        data_string=  json.loads(event.body_as_str(encoding="UTF-8"))
        pred = predict(data_string,dv,model)[0].round(2)

        output = constructoutput(pred,data_string,model)

        
        print(
             'Received the event: "{}" from the partition with ID: "{}"'.format(
                data_string, partition_context.partition_id
            )
        )      
        
        print('------------------------------------')
       
        print(f'Predict result = {pred}')
       
        print('Sending result to output stream...')
       
        
        await  outputresult(output)
        
        print('------------------------------------')
       
    await partition_context.update_checkpoint(event)




async def main():
    # Create an Azure blob checkpoint store to store the checkpoints.
    checkpoint_store = BlobCheckpointStore.from_connection_string(
        BLOB_STORAGE_CONNECTION_STRING, BLOB_CONTAINER_NAME
    )
    model,dv = getmodel()
    # Create a consumer client for the event hub.
    client = EventHubConsumerClient.from_connection_string(
        EVENT_HUB_CONNECTION_STR,
        consumer_group=EVENT_HUB_CONSUMER_GROUP_EVENT,
        eventhub_name=EVENT_HUB_NAME,
        checkpoint_store=checkpoint_store,
    )

    on_event_with_args = functools.partial(on_event, model=model, dv=dv)


    # async with client:
    #     await client.receive(on_event=on_event_with_args, starting_position="-1")

    async with client:
        await client.receive_batch(
            on_event_batch=on_event_with_args,
            starting_position="-1"
        )
    
if __name__ == "__main__":
    print('Consumer Starting...')
    loop = asyncio.get_event_loop()
    # Run the main method.
    loop.run_until_complete(main())