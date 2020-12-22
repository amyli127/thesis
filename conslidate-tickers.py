import csv

output = open("data/consolidated-tickers.csv", "w")
tickers = set()

with open("data/consolidated-sites-tickers.csv", "r") as csvFile:
    reader = csv.DictReader(csvFile, fieldnames=("url", "ticker"))
    for row in reader:
        ticker = row["ticker"]
        if ticker not in tickers:
            output.write(row["ticker"] + "\n")        
            tickers.add(ticker)
    csvFile.close()
output.close()
