import csv


url_to_sum = {}                 # map from url to sum of pageviews (used to calc avg)
url_to_count = {}               # map from url to number of occurrences (used to calc avg)
url_to_avg_pageviews = {}       # map from url to avg pageviews per million

url_to_adex = {}                # map from url to ad expenditure (not proportional)
url_to_ticker = {}
ticker_to_pageviews = {}

url_to_proportional_adex = {}   

# read in pageview info
with open("data/total-info-2017.csv", "r") as total_activity:
    reader = csv.DictReader(total_activity)
    for row in reader:
        url = row["Url"]
        adex = row["xad"]
        pageviews = row["PageviewsPerMillion"]
        ticker = row["tic"]

        if url not in url_to_adex:
            url_to_adex[url] = 0 if not adex else float(adex)
        
        if url not in url_to_ticker:
            url_to_ticker[url] = ticker

        if not pageviews:
            continue

        if ticker in ticker_to_pageviews:
            ticker_to_pageviews[ticker] = ticker_to_pageviews[ticker] + float(pageviews)
        else:
            ticker_to_pageviews[ticker] = float(pageviews)

        if url in url_to_sum:
            url_to_sum[url] = url_to_sum[url] + float(pageviews)
        else:
            url_to_sum[url] = float(pageviews)

        if url in url_to_count:
            url_to_count[url] = url_to_count[url] + 1
        else:
            url_to_count[url] = 1


# calculate proportional adex
for url in url_to_sum:
    ticker = url_to_ticker[url]
    proportional_pageviews = url_to_sum[url] / ticker_to_pageviews[ticker]
    url_to_proportional_adex[url] = 0 if url_to_adex[url] == 0 else round(proportional_pageviews * url_to_adex[url], 2)


HEADER = "Url,Date,PageviewsPerMillion,PageviewsPerUser,Rank,ReachPerMillion,gvkey,datadate,fyear,tic,conm,curcd,revt,sale,xad,exch,wxad\n"

# write weighted adex
with open("data/total-info1.csv", "r") as total_activity, open("data/total-info1.csv", "r") as total_activity1:
    with open("data/total-info-weighted2.csv", "w") as output:
        reader = csv.DictReader(total_activity)
        for i, (forUrl, toRead) in enumerate(zip(reader, total_activity1)):
            if i == 0:
                output.write(HEADER)
            else:
                url = forUrl["Url"]
                toRead = toRead.rstrip('\n')
                newline = toRead + "," + str(url_to_proportional_adex[url]) + '\n'
                output.write(newline)