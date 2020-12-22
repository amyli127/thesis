import requests
import csv

# open file with urls

# setup query fields
API_key = "7H9WrorbrZ2gNI3U696P64wQe6jKlG5Xa9CQakn7"
url = "zoom.us"
company = "zoom"
headers = {'x-api-key': API_key}
startdate = "20180501"

# make API call
query = "https://awis.api.alexa.com/api?Action=TrafficHistory&Range=31&ResponseGroup=History&Start=" + startdate + "&Url=" + url + "&Output=json"
response = requests.get(query, headers=headers)
data = response.json()

# extract fields from response
siteData = data["Awis"]["Results"]["Result"]["Alexa"]["TrafficHistory"]["HistoricalData"]["Data"]
argumentData = data["Awis"]["Results"]["Result"]["Alexa"]["Request"]["Arguments"]["Argument"]
urlOne = [x["Value"] for x in argumentData if x["Name"] == "url"]
url = urlOne[0]

# write response to file
f = csv.writer(open("data/" + company + ".csv", "w"))
f.writerow(["Url", "Date", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion"])

for row in siteData:
    f.writerow([url,
                row["Date"],
                row["PageViews"]["PerMillion"],
                row["PageViews"]["PerUser"],
                row["Rank"],
                row["Reach"]["PerMillion"]])