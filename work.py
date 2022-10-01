#Importing Models
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib as plt
import sklearn
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

#Sample API Request from Database
result = [{'objectId': 'tYjHvpJewn', 'owner': {'__type': 'Pointer', 'className': '_User', 'objectId': 'ALwgzcmUSJ'}, 'Time': '10/1 14:38', 'Food_Type': 'HotDog', 'Food_Weight': '200g', 'Eaten_Before': 'Breakfast', 'createdAt': '2022-10-01T18:39:10.700Z', 'updatedAt': '2022-10-01T18:39:10.700Z'}, {'objectId': 'DFjb0tNkXZ', 'owner': {'__type': 'Pointer', 'className': '_User', 'objectId': 'ALwgzcmUSJ'}, 'Time': '10/1 14:38', 'Food_Type': 'HotDog', 'Food_Weight': '200g', 'Eaten_Before': 'Dinner', 'createdAt': '2022-10-01T18:39:32.250Z', 'updatedAt': '2022-10-01T18:39:32.250Z'}, {'objectId': 'uoLKLC5xOn', 'owner': {'__type': 'Pointer', 'className': '_User', 'objectId': 'ALwgzcmUSJ'}, 'Time': '10/1 14:38', 'Food_Type': 'HotDog', 'Food_Weight': '200g', 'Eaten_Before': 'Lunch', 'createdAt': '2022-10-01T18:39:34.846Z', 'updatedAt': '2022-10-01T18:39:34.846Z'}, {'objectId': '2AM1c1gRxN', 'owner': {'__type': 'Pointer', 'className': '_User', 'objectId': 'ALwgzcmUSJ'}, 'Time': '10/1 14:38', 'Food_Type': 'HotDog', 'Food_Weight': '200g', 'Eaten_Before': 'None', 'createdAt': '2022-10-01T18:39:37.922Z', 'updatedAt': '2022-10-01T18:39:37.922Z'}]

#Cleaning the data into more legible dictionaries
waste = []
for i in range(len(result)):
    waste += [int(result[i]['Food_Weight'][0:3])]
    
time = []
for i in range(len(result)):
    time += [int(result[i]['Time'][5:7])]
    # time_min = [int(result[i]['Time'][8:10])]
 
breakfast = []
lunch = []
dinner = []
none = []
for i in range(len(result)):
    if(result[i]['Eaten_Before'] == 'Breakfast'):
        breakfast.append(1)
    else: 
        breakfast.append(0)
 
    if(result[i]['Eaten_Before'] == 'Dinner'):
        dinner.append(1)
    else: 
        dinner.append(0)
    
    if(result[i]['Eaten_Before'] == 'Lunch'):
        lunch.append(1)
    else: 
        lunch.append(0)
 
    if(result[i]['Eaten_Before'] == 'None'):
        none.append(1)
    else: 
        none.append(0)
    
 

#Converting dictionaries into Dataframes for Analysis

food = {'waste': waste, 'time': time, 'breakfast': breakfast, 'lunch': lunch, 'dinner': dinner, 'none': none }
newdf = pd.DataFrame(food, columns=['time', 'breakfast', 'lunch', 'dinner', 'none'])
wastedf = pd.DataFrame(food, columns=['waste'])
print(newdf)

#MACHINE LEARNING MODEL

#Instantiating our Linear Regression Model
ourmodel = LinearRegression()


#Creating our data splits
X_train, X_test, y_train, y_test = train_test_split(newdf, wastedf, test_size=0.3, random_state=101)

#Training the model
ourmodel.fit(X_train, y_train)

#Function that predicts whether or not you will waste food with an arbitrary set of 
# values of independent variables.

def predictwaste(info):
    newpred = ourmodel.predict(info)
    if newpred > 5:
        return  True
    else:
        return False
