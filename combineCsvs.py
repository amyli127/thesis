import csv

fileReader = open("GOOGL_2018_XAD.csv", "r")
csvReader = csv.reader(fileReader)
fileWriter = open('google_activity.csv', 'a')
csvWriter = csv.writer(fileWriter)

rHeaders = next(fileReader)
rHeadersStr = ''.join(rHeaders)
# print(rHeaders)

googleDataToWrite = next(fileReader)
googleDataToWriteStr = ''.join(googleDataToWrite)

# for i, row in enumerate(fileReader):
#     if i == 0:
#         csvWriter.write(rHeadersStr)
#     csvWriter.write(googleDataToWriteStr)

with fileWriter as file:
    file.write(googleDataToWriteStr)
