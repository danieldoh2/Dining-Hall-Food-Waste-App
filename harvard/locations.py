import requests

# Get locations
response = requests.get("https://api.cs50.io/dining/locations")

# Convert JSON to list of dicts
locations = response.json()

# Print each location's name
for location in locations:
    print(location["name"])