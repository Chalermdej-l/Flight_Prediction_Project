from sklearn.feature_extraction import DictVectorizer
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.linear_model import LinearRegression
import pandas as pd
import matplotlib.pyplot as plt
import pickle
pd.options.mode.chained_assignment = None

def convert_timeperiod(time):
    time = int(time)
    hour = int(time / 100)
    minute = (time % 100)//30
    time  =hour + minute
    if   6 <= time <= 11 :
        result = 'Morning'
    elif 11 <= time <= 17 :
        result = 'Afternoon'
    elif 17 <= time <= 20 :
        result = 'Evening'
    elif 20 <= time <= 24 :
        result = 'Night'
    elif time <= 3 :
        result = 'Night'     
    else:
        result= 'EarlyMorning'  

    return result

def convert_preprocess(data,process=None,mode=None):
    if mode:
        process = process.fit(data)
        con_data = process.transform(data)
    else:
        con_data = process.transform(data)
    return con_data,process

def eveulatemodel(y_true,predict):    
    score =  mean_squared_error(y_true,predict)
    r2score =  r2_score(y_true,predict)
    print(f'rmse score {score}')
    print(f'r2 score {r2score}')
    plt.scatter(predict,y_true,c='red')
    p1 = max(max(predict), max(y_true))
    p2 = min(min(predict), min(y_true))
    plt.plot([p1, p2], [p1, p2], 'b-')
    plt.xlabel('True Values', fontsize=15)
    plt.ylabel('Predictions', fontsize=15)
    plt.axis('equal')
    plt.show()

    return score,r2_score

def preparedata(data):    
    # Convert data type and feature engineering
    data['CRSDepTime'] = data.CRSDepTimeHour.astype('string')+ data.CRSDepTimeMinute.astype('string').str.zfill(2)
    data['WheelsOff'] = data.WheelsOffHour.astype('string')+ data.WheelsOffMinute.astype('string').str.zfill(2)
    data['CRSArrTime'] = data.CRSArrTimeHour.astype('string')+ data.CRSArrTimeMinute.astype('string').str.zfill(2)
    data['origin_state'] = data['OriginCityName'].apply(lambda x: x[x.rfind(' ')+1:])
    data['dest_state'] = data['DestCityName'].apply(lambda x: x[x.rfind(' ')+1:])
    data['state_combine'] = data['origin_state'] +'_' + data['dest_state']
    data['location_yn'] = (data['origin_state'] == data['dest_state']).astype('int')
    data.Holidays = (data.Holidays).astype('int')

    data['CRSDepTimeHourDis'] = data.CRSDepTime.apply(lambda x: convert_timeperiod(x))
    data['WheelsOffHourDis'] = data.WheelsOff.apply(lambda x: convert_timeperiod(x))
    data['CRSArrTimeHourDis'] = data.CRSArrTime.apply(lambda x: convert_timeperiod(x))
    
    # Take the top 25 location to convert parameter
    top_state = ['CA_CA', 'TX_TX', 'NY_FL', 'FL_NY', 'CA_TX', 'TX_CA', 'FL_TX', 'HI_HI', 'TX_FL', 'FL_GA', 'CA_NV', 'NV_CA', 'GA_FL', 'CA_WA', 'CA_AZ', 'AZ_CA', 'WA_CA', 'CA_CO', 'CO_CA', 'FL_NC', 'NC_FL', 'TX_CO', 'CO_TX', 'NJ_FL', 'FL_NJ', 'IL_FL', 'FL_IL', 'CA_HI', 'FL_FL', 'HI_CA', 'CO_CO', 'NC_NC', 'NY_NC', 'NY_IL', 'IL_NY', 'NC_NY', 'IL_TX', 'TX_IL', 'WA_WA', 'PA_FL', 'FL_PA', 'LA_TX', 'OR_CA', 'TX_LA', 'CA_OR', 'CA_UT', 'TX_GA', 'DC_FL', 'UT_CA', 'GA_TX']
       
    data['state_combine'] = data['state_combine'].apply(lambda x: x if x in top_state else 'Other')
    
    cat_col = ['Marketing_Airline_Network', 'DayofWeek','Holidays', 'CRSDepTimeHourDis', 'WheelsOffHourDis','CRSArrTimeHourDis', 'state_combine', 'location_yn']
    int_col = [ 'DepDelay', 'TaxiOut', 'CRSElapsedTime','ActualElapsedTime', 'Distance', 'WeatherDelay']

    data = data[cat_col + int_col] 

    return data

def splitdata(data):   
    test,train = train_test_split(data,test_size=0.6,random_state=1)
    train_x = train.drop('ActualElapsedTime',axis=1).to_dict(orient='records')
    train_y = train['ActualElapsedTime'].values
    test_x = test.drop('ActualElapsedTime',axis=1).to_dict(orient='records')
    test_y = test['ActualElapsedTime'].values

    return  train_x,train_y,test_x,test_y

def savemodel(model,dv):
    pickle.dump(model, open('artifact/model.sav', 'wb+'))
    pickle.dump(dv,open('artifact/dv.sav', 'wb+'))


def main():
    print('Loading data...')
    # Loading data  
    df = pd.read_parquet('data/features_added.parquet')
    df = df.query("Year >=2023")
    df.to_parquet('data/filterdata.parquet',index=False)
    df = preparedata(df)

    print('Spliting data...')
    # Split data
    train_x,train_y,test_x,test_y = splitdata(df)
    
    print('Converting data...')
    # Fit DV
    dv= DictVectorizer()
    train_x_dv,dv = convert_preprocess(train_x,dv,'train')
    val_x_dv,dv = convert_preprocess(test_x,dv)
    
    print('Traning model...')
    # Train model
    model = LinearRegression()
    model.fit(train_x_dv,train_y)
    predict = model.predict(val_x_dv)

    print('Scoring model...')
    # Eveulate model
    score,r2_score = eveulatemodel(test_y,predict)
    print(f'Model got score {score}')
    print(f'Model got r2 score {r2_score}')

    print('Save model to output')
    # Save model
    savemodel(model,dv)

if __name__ =="__main__":
    print('Script start...')
    main()