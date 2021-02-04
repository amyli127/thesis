import requests
import csv


# open output file and write headers
output = csv.writer(open("data/web-traffic/2019.csv", "a"))
# output.writerow(["Url", "Date", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion"])


# setup universal query fields
API_key = "UKvA8Oeun51JmSoNrhcYt7sSyhtprZBK6f1zEE90"
headers = {'x-api-key': API_key}


# put start dates into dictionary
start_dates = {}
with open("data/start-dates/start-dates-2019.csv", "r") as csvFile:
    reader = csv.DictReader(csvFile, fieldnames=("start", "length"))
    for row in reader:
        start_dates[row["start"]] = row["length"]
    csvFile.close()


def make_API_call(url, startdate, length):
    # make API call
    query = "https://awis.api.alexa.com/api?Action=TrafficHistory&Range=" + length + "&ResponseGroup=History&Start=" + startdate + "&Url=" + url + "&Output=json"
    response = requests.get(query, headers=headers)
    data = response.json()

    # extract fields from response
    siteData = data["Awis"]["Results"]["Result"]["Alexa"]["TrafficHistory"]["HistoricalData"]["Data"]
    argumentData = data["Awis"]["Results"]["Result"]["Alexa"]["Request"]["Arguments"]["Argument"]
    urlOne = [x["Value"] for x in argumentData if x["Name"] == "url"]
    url = urlOne[0]

    # write response to file
    for row in siteData:
        output.writerow([url,
                    row["Date"],
                    row["PageViews"]["PerMillion"],
                    row["PageViews"]["PerUser"],
                    row["Rank"],
                    row["Reach"]["PerMillion"]])


# loop over urls and make queries for each
with open("data/consolidated-sites2.txt", "r") as f:
    urls = f.read().splitlines()
    for url in urls:
        print(url)
        # make api call for every start date in year
        for startDate in start_dates:
            length = start_dates[startDate]
            make_API_call(url, startDate, length) 
