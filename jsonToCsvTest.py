import pandas
import csv
import json

jsonStr = """{
    "Awis": {
        "OperationRequest": {
            "RequestId": "901effb8-9a31-440f-8eee-a9e82e745e97"
        },
        "Results": {
            "Result": {
                "Alexa": {
                    "Request": {
                        "Arguments": {
                            "Argument": [
                                {
                                    "Name": "start",
                                    "Value": "20180510"
                                },
                                {
                                    "Name": "range",
                                    "Value": "31"
                                },
                                {
                                    "Name": "url",
                                    "Value": "google.com"
                                },
                                {
                                    "Name": "responsegroup",
                                    "Value": "History"
                                }
                            ]
                        }
                    },
                    "TrafficHistory": {
                        "Range": "31",
                        "Site": "google.com",
                        "Start": "2018-05-10",
                        "HistoricalData": {
                            "Data": [
                                {
                                    "Date": "2018-05-10",
                                    "PageViews": {
                                        "PerMillion": "104300",
                                        "PerUser": "7.70"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "504400"
                                    }
                                },
                                {
                                    "Date": "2018-05-11",
                                    "PageViews": {
                                        "PerMillion": "58740",
                                        "PerUser": "4.09"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "496200"
                                    }
                                },
                                {
                                    "Date": "2018-05-12",
                                    "PageViews": {
                                        "PerMillion": "50300",
                                        "PerUser": "3.51"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "477000"
                                    }
                                },
                                {
                                    "Date": "2018-05-13",
                                    "PageViews": {
                                        "PerMillion": "48720",
                                        "PerUser": "3.46"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "478800"
                                    }
                                },
                                {
                                    "Date": "2018-05-14",
                                    "PageViews": {
                                        "PerMillion": "60690",
                                        "PerUser": "4.34"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "506400"
                                    }
                                },
                                {
                                    "Date": "2018-05-15",
                                    "PageViews": {
                                        "PerMillion": "60430",
                                        "PerUser": "4.28"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "504300"
                                    }
                                },
                                {
                                    "Date": "2018-05-16",
                                    "PageViews": {
                                        "PerMillion": "60780",
                                        "PerUser": "4.24"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "505600"
                                    }
                                },
                                {
                                    "Date": "2018-05-17",
                                    "PageViews": {
                                        "PerMillion": "60920",
                                        "PerUser": "4.20"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "503300"
                                    }
                                },
                                {
                                    "Date": "2018-05-18",
                                    "PageViews": {
                                        "PerMillion": "59330",
                                        "PerUser": "4.06"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "498200"
                                    }
                                },
                                {
                                    "Date": "2018-05-19",
                                    "PageViews": {
                                        "PerMillion": "50830",
                                        "PerUser": "3.49"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "476700"
                                    }
                                },
                                {
                                    "Date": "2018-05-20",
                                    "PageViews": {
                                        "PerMillion": "49150",
                                        "PerUser": "3.45"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "478500"
                                    }
                                },
                                {
                                    "Date": "2018-05-21",
                                    "PageViews": {
                                        "PerMillion": "60260",
                                        "PerUser": "4.27"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "503500"
                                    }
                                },
                                {
                                    "Date": "2018-05-22",
                                    "PageViews": {
                                        "PerMillion": "58260",
                                        "PerUser": "4.02"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "503500"
                                    }
                                },
                                {
                                    "Date": "2018-05-23",
                                    "PageViews": {
                                        "PerMillion": "59370",
                                        "PerUser": "4.09"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "503100"
                                    }
                                },
                                {
                                    "Date": "2018-05-24",
                                    "PageViews": {
                                        "PerMillion": "58810",
                                        "PerUser": "4.05"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "500900"
                                    }
                                },
                                {
                                    "Date": "2018-05-25",
                                    "PageViews": {
                                        "PerMillion": "56660",
                                        "PerUser": "3.88"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "494300"
                                    }
                                },
                                {
                                    "Date": "2018-05-26",
                                    "PageViews": {
                                        "PerMillion": "49950",
                                        "PerUser": "3.45"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "475500"
                                    }
                                },
                                {
                                    "Date": "2018-05-27",
                                    "PageViews": {
                                        "PerMillion": "48100",
                                        "PerUser": "3.41"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "475800"
                                    }
                                },
                                {
                                    "Date": "2018-05-28",
                                    "PageViews": {
                                        "PerMillion": "56630",
                                        "PerUser": "3.97"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "500700"
                                    }
                                },
                                {
                                    "Date": "2018-05-29",
                                    "PageViews": {
                                        "PerMillion": "61870",
                                        "PerUser": "4.40"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "504900"
                                    }
                                },
                                {
                                    "Date": "2018-05-30",
                                    "PageViews": {
                                        "PerMillion": "61880",
                                        "PerUser": "4.37"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "503800"
                                    }
                                },
                                {
                                    "Date": "2018-05-31",
                                    "PageViews": {
                                        "PerMillion": "62190",
                                        "PerUser": "4.41"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "502400"
                                    }
                                },
                                {
                                    "Date": "2018-06-01",
                                    "PageViews": {
                                        "PerMillion": "70490",
                                        "PerUser": "5.15"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "496500"
                                    }
                                },
                                {
                                    "Date": "2018-06-02",
                                    "PageViews": {
                                        "PerMillion": "52830",
                                        "PerUser": "3.70"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "476800"
                                    }
                                },
                                {
                                    "Date": "2018-06-03",
                                    "PageViews": {
                                        "PerMillion": "49950",
                                        "PerUser": "3.67"
                                    },
                                    "Rank": "2",
                                    "Reach": {
                                        "PerMillion": "479100"
                                    }
                                },
                                {
                                    "Date": "2018-06-04",
                                    "PageViews": {
                                        "PerMillion": "66940",
                                        "PerUser": "4.91"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "507500"
                                    }
                                },
                                {
                                    "Date": "2018-06-05",
                                    "PageViews": {
                                        "PerMillion": "67460",
                                        "PerUser": "4.93"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "507800"
                                    }
                                },
                                {
                                    "Date": "2018-06-06",
                                    "PageViews": {
                                        "PerMillion": "72540",
                                        "PerUser": "5.48"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "507600"
                                    }
                                },
                                {
                                    "Date": "2018-06-07",
                                    "PageViews": {
                                        "PerMillion": "118700",
                                        "PerUser": "9.16"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "503200"
                                    }
                                },
                                {
                                    "Date": "2018-06-08",
                                    "PageViews": {
                                        "PerMillion": "116200",
                                        "PerUser": "8.84"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "498300"
                                    }
                                },
                                {
                                    "Date": "2018-06-09",
                                    "PageViews": {
                                        "PerMillion": "105800",
                                        "PerUser": "7.90"
                                    },
                                    "Rank": "1",
                                    "Reach": {
                                        "PerMillion": "480200"
                                    }
                                }
                            ]
                        }
                    }
                }
            },
            "ResponseStatus": {
                "StatusCode": "200"
            }
        }
    }
}"""

# df = pandas.read_json(jsonStr)
# df.to_csv("google.csv")

data = json.loads(jsonStr)
googleData = data["Awis"]["Results"]["Result"]["Alexa"]["TrafficHistory"]["HistoricalData"]["Data"]
argumentData = data["Awis"]["Results"]["Result"]["Alexa"]["Request"]["Arguments"]["Argument"]
urlOne = [x["Value"] for x in argumentData if x["Name"] == "url"]
url = urlOne[0]
print(url)

f = csv.writer(open("google.csv", "w"))
f.writerow(["Url", "Date", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion"])

for row in googleData:
    f.writerow([url,
                row["Date"],
                row["PageViews"]["PerMillion"],
                row["PageViews"]["PerUser"],
                row["Rank"],
                row["Reach"]["PerMillion"]])