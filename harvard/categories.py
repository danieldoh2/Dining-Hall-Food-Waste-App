import requests

# Get categories
response = requests.get("https://api.cs50.io/dining/categories")

# Convert JSON to list of dicts
categories = response.json()

# Print each category's name
for category in categories:
    print(category["name"])