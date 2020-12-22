import glob, os

consolidated_sites = open("data/consolidated-sites.txt", "w")
sites = set()

os.chdir("data/sites")
for fileName in glob.glob("*.txt"):
    with open(fileName, "r") as f:
        for line in f:
            if line not in sites:
                consolidated_sites.write(line)
                sites.add(line)
    f.close()

consolidated_sites.close()

