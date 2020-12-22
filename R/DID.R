library(foreign)

# read in data
activity <- read.csv('web-traffic/batch2.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
#vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "xad", "tic")
#activity_filtered <- activity[vars]
activity_filtered <- activity

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# create dummy var to indicate before or after treatment
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$did = activity_filtered$time * activity_filtered$treated

# estimate DID estimator
didreg = lm(PageviewsPerMillion ~ treated + time + did, data = activity_filtered)
summary(didreg)