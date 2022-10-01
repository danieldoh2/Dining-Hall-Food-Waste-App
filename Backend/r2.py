import requests

# Get categories
response = requests.get("https://api.cs50.io/dining/recipes")

# Convert JSON to list of dicts
recipes = response.json()

CaloriesList = []
rows, cols = len(recipes), 2

# Print each recipe's name
for recipe in recipes:
    calorieslist = {'Name': recipe["name"], 'Calories': recipe["calories"]}
    print(recipe["name"])
    print("calories: ", recipe["calories"])

    CaloriesList += [[recipe["name"], recipe["calories"]]]

print(CaloriesList)

a = ""
food = input("Please enter in your food item: ")
for i in range(len(CaloriesList)):
    if (food == CaloriesList[i][0]):
        a = CaloriesList[i][1]
        if (a == None):
            print(0)
            break
        print(int(CaloriesList[i][1]))




