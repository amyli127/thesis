library(foreign)
library(lubridate)
library(sjPlot)
library(sjmisc)
library(sjlabelled)

# read in data
activity <- read.csv('total-info-weighted-2018-new.csv', header=TRUE, sep=',')
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
med_revt = median(activity_filtered$revt)
activity_filtered$spending = ifelse(activity_filtered$revt <= med_revt, 0, 1)

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

# FILTER TO 10 WEEKS BEFORE AND AFTER
activity_filtered = activity_filtered[activity_filtered$week >= 11 & activity_filtered$week <= 31, ]
activity_filtered$week_bin <- as.factor(activity_filtered$week)
activity_filtered$month_bin <- as.factor(activity_filtered$yr_month)

# FILTER TO 95th percentile
ninetyfifth_percentile_xad = quantile(activity_filtered$wxad, 0.90)
activity_filtered = activity_filtered[activity_filtered$wxad <= ninetyfifth_percentile_xad, ]

# relevel binary FE variables
activity_filtered <- within(activity_filtered, week_bin <- relevel(week_bin, ref = "20"))
activity_filtered <- within(activity_filtered, month_bin <- relevel(month_bin, ref = "17"))

# URL fixed effects
activity_filtered$url_bin <- as.factor(activity_filtered$Url)

# estimate DID estimator
dddreg_censored = lm(log(PageviewsPerMillion) ~ treated + spending + 
                       time_treated + time_spending + spending_treated + time_treated_spending + week_bin + url_bin,
                     data = activity_filtered)

dddreg_peruser_censored = lm(log(PageviewsPerUser) ~ treated + spending + 
                               time_treated + time_spending + spending_treated + time_treated_spending + week_bin + url_bin,
                             data = activity_filtered)

dddreg_reach_censored = lm(log(ReachPerMillion) ~ treated + spending + 
                             time_treated + time_spending + spending_treated + time_treated_spending + week_bin + url_bin,
                           data = activity_filtered)


tab_model(dddreg_censored, dddreg_peruser_censored, dddreg_reach_censored,
          terms = c("time_treated_spending"),
          p.style = "stars",
          collapse.se = TRUE,
          show.ci = FALSE,
          string.pred = "Coeffcient")

summary(dddreg)
