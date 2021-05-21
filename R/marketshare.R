library(foreign)
library(lubridate)
library(ggplot2)

# read in data
adex <- read.csv('ad-ex/batch2-filtered.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

sum(adex$xad, na.rm = TRUE)


