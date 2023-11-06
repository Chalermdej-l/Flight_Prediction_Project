import asyncio
import json
import pandas as pd
import os
# import logging
from azure.eventhub import EventData
from azure.eventhub.aio import EventHubProducerClient

EVENT_HUB_CONNECTION_STR = os.getenv("EVENT_HUB_CONNECTION_PRODUCER_SEND_KEY") 
EVENT_HUB_NAME = os.getenv("EVENT_HUB_NAME_PRODUCER")

async def run():
    producer = EventHubProducerClient.from_connection_string(
        conn_str=EVENT_HUB_CONNECTION_STR, eventhub_name=EVENT_HUB_NAME
    )
    print('Fecing data....')
    # logging.info('Fecing data....')
    data = fetchtestrecord()

    print('Push event to Event hub...')
    # logging.info('Push event to Event hub...')
    async with producer:

        for item in data:

            # Create a batch.
            event_data_batch = await producer.create_batch()

            event_data_batch.add(EventData(json.dumps(item)))

            # Send the batch of events to the event hub.
            await producer.send_batch(event_data_batch)

    print('Finish pushing event...')
    # logging.info('Finish pushing event...')
    
def fetchtestrecord():
    data = open('data/samplerecord','r')  
    data = json.load(data)
    return data

if __name__ == "__main__":
    print('Producer Starting...')
    asyncio.run(run())

