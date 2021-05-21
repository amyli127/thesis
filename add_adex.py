import csv


adex_info = {}          # map from ticker to line of adex info
url_to_ticker = {}      # dict from url to ticker


HEADER = "Url,Date,PageviewsPerMillion,PageviewsPerUser,Rank,ReachPerMillion,gvkey,datadate,fyear,tic,conm,curcd,revt,sale,xad,exch\n"

# populate adex info
with open("data/ad-ex/batch2.csv", "r") as adex, open("data/ad-ex/batch2.csv", "r") as adex1:
    content = adex.readlines()
    reader = csv.DictReader(adex1)
    for i, row in enumerate(reader):
        if i == 0:
            continue
        ticker = row["tic"]
        adex_info[ticker] = content[i]


# populate map from URL to ticker
with open("data/consolidated-sites-tickers.csv", "r") as csvFile:
    reader = csv.DictReader(csvFile, fieldnames=("url", "ticker"))
    for row in reader:
        ticker = row["ticker"]
        url_to_ticker[row["url"]] = ticker


# consolidate info
with open("data/web-traffic/2019.csv", "r") as web_traffic, open("data/web-traffic/2019.csv", "r") as web_traffic1:
    with open("data/total-info-2019.csv", "w") as output:
        reader = csv.DictReader(web_traffic)
        for i, (line, line1) in enumerate(zip(reader, web_traffic1)):
            # write header
            if i == 0:
                output.write(HEADER)
            else:
                url = line["Url"]
                ticker = url_to_ticker[url]
                line1 = line1.rstrip('\n')
                newline = line1 + "," + adex_info[ticker]
                output.write(newline)

