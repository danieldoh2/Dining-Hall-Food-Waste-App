import requests

# Get categories
response = requests.get("https://api.cs50.io/dining/recipes")

# Convert JSON to list of dicts
recipes = response.json()

CaloriesList = []
rows, cols =  len(recipes),len(recipes)

CaloriesList = [[cols]rows]

# Print each recipe's name
for recipe in recipes:
    calorieslist = {'Name': recipe["name"], 'Calories': recipe["calories"]}
    print(recipe["name"])
    print("calories: ", recipe["calories"])
    
    

    CaloriesList += [calorieslist["Name"], calorieslist["Calories"]]

print()
print(CaloriesList)

