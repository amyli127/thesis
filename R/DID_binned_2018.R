library(foreign)
library(lubridate)

# read in data
activity <- read.csv('total-info1.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]
activity_filtered$month <- month(activity_filtered$Date)

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# month dummy vars
activity_filtered$jan <- ifelse(activity_filtered$month == 1, 1, 0)
activity_filtered$feb <- ifelse(activity_filtered$month == 2, 1, 0)
activity_filtered$mar <- ifelse(activity_filtered$month == 3, 1, 0)
activity_filtered$apr <- ifelse(activity_filtered$month == 4, 1, 0)
activity_filtered$may <- ifelse(activity_filtered$month == 5, 1, 0)
activity_filtered$jun <- ifelse(activity_filtered$month == 6, 1, 0)
activity_filtered$jul <- ifelse(activity_filtered$month == 7, 1, 0)
activity_filtered$aug <- ifelse(activity_filtered$month == 8, 1, 0)
activity_filtered$sep <- ifelse(activity_filtered$month == 9, 1, 0)
activity_filtered$oct <- ifelse(activity_filtered$month == 10, 1, 0)
activity_filtered$nov <- ifelse(activity_filtered$month == 11, 1, 0)
activity_filtered$dec <- ifelse(activity_filtered$month == 12, 1, 0)


# create interactions betw months and treatment
activity_filtered$jan_treated = activity_filtered$jan * activity_filtered$treated
activity_filtered$feb_treated = activity_filtered$feb * activity_filtered$treated
activity_filtered$mar_treated = activity_filtered$mar * activity_filtered$treated
activity_filtered$apr_treated = activity_filtered$apr * activity_filtered$treated
activity_filtered$may_treated = activity_filtered$may * activity_filtered$treated
activity_filtered$jun_treated = activity_filtered$jun * activity_filtered$treated
activity_filtered$jul_treated = activity_filtered$jul * activity_filtered$treated
activity_filtered$aug_treated = activity_filtered$aug * activity_filtered$treated
activity_filtered$sep_treated = activity_filtered$sep * activity_filtered$treated
activity_filtered$oct_treated = activity_filtered$oct * activity_filtered$treated
activity_filtered$nov_treated = activity_filtered$nov * activity_filtered$treated
activity_filtered$dec_treated = activity_filtered$dec * activity_filtered$treated


# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated +
              jan + feb + mar + apr + may + jun + jul + aug + sep + nov + dec +
              jan_treated + feb_treated + mar_treated + apr_treated + may_treated + jun_treated + jul_treated + aug_treated + sep_treated + nov_treated + dec_treated,
            data = activity_filtered)
summary(didreg)