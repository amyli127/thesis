library(foreign)
library(lubridate)

# read in data
activity <- read.csv('total-info-weighted-2018.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "wxad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$wxad), ]

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$year <- year(activity_filtered$Date)
activity_filtered$week <- week(activity_filtered$Date)
activity_filtered$yr_week <- 52 * (activity_filtered$year - 2017) + activity_filtered$week
activity_filtered$yr_month <- 12 * (activity_filtered$year - 2017) + activity_filtered$month

# create dummy var to indicate > or <= median xad
med_xad = median(activity_filtered$wxad)
activity_filtered$spending = ifelse(activity_filtered$wxad <= med_xad, 0, 1)

# create dummy var to indicate before or after treatment
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$time_treated = activity_filtered$time * activity_filtered$treated

# create interaction term between the time and spending
activity_filtered$time_spending = activity_filtered$time * activity_filtered$spending

# create interaction term between spending and treated
activity_filtered$spending_treated = activity_filtered$spending * activity_filtered$treated

# create interaction term between time, treated, and spending
activity_filtered$time_treated_spending = activity_filtered$time * activity_filtered$treated * activity_filtered$spending

# activity_filtered = activity_filtered[activity_filtered$week >= 11 & activity_filtered$week <= 31, ]
activity_filtered$week_bin <- as.factor(activity_filtered$week)
activity_filtered$month_bin <- as.factor(activity_filtered$yr_month)

activity_filtered <- within(activity_filtered, week_bin <- relevel(week_bin, ref = "20"))
activity_filtered <- within(activity_filtered, month_bin <- relevel(month_bin, ref = "17"))

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + time + spending + 
              time_treated + time_spending + spending_treated + time_treated_spending + month_bin,
            data = activity_filtered)
summary(didreg)
