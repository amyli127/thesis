library(foreign)

# read in data
activity <- read.csv('total-info1.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# change xad to be proportional to pageviews


# create dummy var to indicate before or after treatment
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$did = activity_filtered$time * activity_filtered$treated

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + time + did, data = activity_filtered)
summary(didreg)