library(foreign)
library(lubridate)
library(ggplot2)

# read in data
activity <- read.csv('total-info-2017-2019.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")
activity_filtered$year <- year(activity_filtered$Date)
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$day <- day(activity_filtered$Date)
activity_filtered = filter(activity_filtered, month == 5 & day > 7 & day < 29)

# create dummy var to indicate before or after regulation
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$time_treated = activity_filtered$time * activity_filtered$treated

# create interaction term between month and treatment
activity_filtered$day_treated = activity_filtered$day * activity_filtered$treated

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + time + day + time_treated + day_treated,
            data = activity_filtered)
summary(didreg)