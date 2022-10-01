# Used to connect to the Back4App Database

import json
import http.client as httplib
import os
from openpyxl import load_workbook
import platform
import haversine as hs
from openpyxl.styles import colors
from openpyxl.styles import Font, Color
import datetime

connection = httplib.HTTPSConnection('parseapi.back4app.com', '443')

connection.connect()
connection.request('GET', '/classes/FoodInfo', '', {
    "X-Parse-Application-Id": "5fm5nJxryhTUr0YaI8gvbZB9HD3wk4MAVtQY0gkr",
    "X-Parse-REST-API-Key": "cnpvLtVctHvm3m8zYeGhYUutQiQEdfQTHN7Voy7G"
})
result = json.loads(connection.getresponse().read())

print(result["results"])
