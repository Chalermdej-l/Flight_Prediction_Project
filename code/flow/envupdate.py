import json

def getoutput():
    with open(file=r'infra\terraform.tfstate',mode='r') as e:
        con = e.read()
    data_json = json.loads(con)['outputs']
    return data_json

def main():
    print('reading output data...')
    data_json = getoutput()
    EVENT_HUB_CONNECTION_PRODUCER_SEND_KEY = data_json['eventhub_producer_send_auth_rule']['value']
    EVENT_HUB_CONNECTION_PRODUCER_LISTEN_KEY = data_json['eventhub_producer_listen_auth_rule']['value']
    EVENT_HUB_CONNECTION_CONSUMER_LISTEN_KEY = data_json['eventhub_consumer_listen_auth_rule']['value']
    EVENT_HUB_CONNECTION_CONSUMER_SEND_KEY = data_json['eventhub_consumer_send_auth_rule']['value']
    BLOB_STORAGE_CONNECTION_PRODUCER = data_json['consumer_connection_string']['value']
    BLOB_STORAGE_CONNECTION_CONSUMER = data_json['predict_connection_string']['value']
    print('update to env file...')
    with open(file='.env',mode='a') as e:
        e.write(f'EVENT_HUB_CONNECTION_PRODUCER_SEND_KEY = "{EVENT_HUB_CONNECTION_PRODUCER_SEND_KEY}"')
        e.write('\n')
        e.write(f'EVENT_HUB_CONNECTION_PRODUCER_LISTEN_KEY = "{EVENT_HUB_CONNECTION_PRODUCER_LISTEN_KEY}"')
        e.write('\n')
        e.write(f'EVENT_HUB_CONNECTION_CONSUMER_LISTEN_KEY = "{EVENT_HUB_CONNECTION_CONSUMER_LISTEN_KEY}"')
        e.write('\n')
        e.write(f'EVENT_HUB_CONNECTION_CONSUMER_SEND_KEY = "{EVENT_HUB_CONNECTION_CONSUMER_SEND_KEY}"')
        e.write('\n')
        e.write(f'BLOB_STORAGE_CONNECTION_PRODUCER = "{BLOB_STORAGE_CONNECTION_PRODUCER}"')
        e.write('\n')
        e.write(f'BLOB_STORAGE_CONNECTION_CONSUMER = "{BLOB_STORAGE_CONNECTION_CONSUMER}"')
    print('Script done')
    
if __name__ == "__main__":
    print('Script start...')
    main()