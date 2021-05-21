import csv


fileReader = open("GOOGL_2018_XAD.csv", "r")
csvReader = csv.reader(fileReader)

rHeaders = next(fileReader)
rHeadersStr = ''.join(rHeaders)

googleDataToWrite = next(fileReader)
googleDataToWriteStr = ''.join(googleDataToWrite)

with open('google_activity.csv', 'r') as istr:
    with open('google_activity_xad.csv', 'w') as ostr:
        for i, line in enumerate(istr):
            if i == 0:
                line = line.rstrip('\n') + rHeadersStr
            else:
                line = line.rstrip('\n') + googleDataToWriteStr
                # print(line, file=ostr)
            ostr.write(line)
