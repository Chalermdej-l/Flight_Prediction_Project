import pandas as pd
import uuid 
import random

def genmockdata(data):
    new_data = []

    num_row = 0

    for index,record in data.iterrows():    
        num_row = 0
        for row in range(5):
            
            if record['WeatherDelay']:
                depdelay_weather = [0,random.randint(0,30) ][random.randint(0,1)]
                record['WeatherDelay'] += depdelay_weather

            else:
                depdelay_taxi = [0,random.randint(0,30) ][random.randint(0,1)]
                if record['TaxiOut']:
                
                    if depdelay_taxi:
                        record['TaxiOut'] += random.randint(0,30) 
                    else:
                        record['WeatherDelay'] += random.randint(1,30)     
                else:
                    depdelay_pos = random.randint(1,30*(1+num_row))
                    depdelay_neg = random.randint(-30*(1+num_row),-1)
                    depdelay_ran = [depdelay_neg,0,depdelay_pos][random.randint(0,2)]

                    if record['DepDelay']:                  

                        if depdelay_ran <=0:
                            # record['DepDelay'] += depdelay_ran
                            record['TaxiOut'] += random.randint(1,30) 
                        else :
                            record['DepDelay'] += depdelay_ran

                    else:                    
                        record['DepDelay'] += depdelay_ran
            num_row+=1
            _record = record.copy()
            new_data.append(_record)
    df_new = pd.DataFrame(new_data)
    return df_new

def main():
    
    df = pd.read_parquet('features_added.parquet')

    used_col = [ 'FlightDate', 'CRSElapsedTime', 'Distance','Marketing_Airline_Network', 'DayofWeek','Holidays','CRSDepTimeHour','CRSDepTimeMinute' ,'CRSArrTimeHour','CRSArrTimeMinute','DestCityName','OriginCityName'] 

    sample_record = 3000
    df_sample = df[used_col].sample(sample_record).sort_values('FlightDate').reset_index(drop=True)
    df_sample['FlightID'] = [str(uuid.uuid4()) for i in range(sample_record) ]
    df_sample[['DepDelay', 'TaxiOut','WeatherDelay']] = 0.0
    df_sample[['WheelsOffHour','WheelsOffMinute']] = df_sample[['CRSDepTimeHour', 'CRSDepTimeMinute']]

    df_new = genmockdata(df_sample)

    df_new['new_taxi'] = pd.to_datetime((df_new.WheelsOffHour.astype('string') + df_new.WheelsOffMinute.astype('string').str.zfill(2)),format='%H%M') +  pd.to_timedelta(df_new.DepDelay + df_new.TaxiOut, unit='m')
    df_new['WheelsOffHour'] = df_new['new_taxi'].dt.hour
    df_new['WheelsOffMinute'] = df_new['new_taxi'].dt.minute
    df_new.drop('new_taxi',axis=1,inplace=True)

    df_combine= pd.concat([df_new,df_sample],axis=0)
    df_combine = df_combine.sort_values(['FlightID','DepDelay','TaxiOut','WeatherDelay']).reset_index(drop=True)
    df_combine.to_csv('../../data/sample_data.parquet',index=False)

    data_json = df_combine.to_json(orient='records')
    with open('../../data/samplerecord.json','w+') as file:
        file.write(data_json)

if __name__ =="__main__":
    main()

