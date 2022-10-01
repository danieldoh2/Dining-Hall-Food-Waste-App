import requests

# Get Annenberg Hall's lunch menu for 2019-12-02
response = requests.get("https://api.cs50.io/dining/menus", {"date": "2019-12-02", "location": 7, "meal": 1})

# Convert JSON to list of dicts
menu = response.json()

# Print number of recipes on menu
print(len(menu))

for key in menu:
    print(key["recipe"])
