library(foreign)
library(lubridate)

# read in data
activity <- read.csv('total-info-2018.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")
activity_filtered$year <- year(activity_filtered$Date)

# create dummy var to indicate month
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$yr_month <- 12 * (activity_filtered$year - 2017) + activity_filtered$month

# create dummy var to indicate before or after regulation
treatment_date = as.Date("2018-05-25")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$time_treated = activity_filtered$time * activity_filtered$treated

# create interaction term between month and treatment
activity_filtered$month_treated = activity_filtered$month * activity_filtered$treated

# estimate DID estimator
didreg1 = lm(log(PageviewsPerMillion) ~ treated + time + month + time_treated + month_treated,
            data = activity_filtered)
summary(didreg)