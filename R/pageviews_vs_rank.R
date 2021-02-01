library(foreign)

# read in data
activity <- read.csv('total-info-weighted1.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "wxad", "tic", "revt", "sale")
activity_filtered <- activity[vars]

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ Rank, data = activity_filtered)
summary(didreg)
