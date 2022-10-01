import requests

# Get categories
response = requests.get("https://api.cs50.io/dining/recipes")

# Convert JSON to list of dicts
recipes = response.json()

# Print each recipe's name
for recipe in recipes:
    print(recipe["name"])
    print("calories: ", recipe["calories"])
    print()