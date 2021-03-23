library(foreign)
library(lubridate)
library(dplyr)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(lme4)

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
activity_filtered$week <- week(activity_filtered$Date)
activity_filtered$yr_month <- 12 * (activity_filtered$year - 2017) + activity_filtered$month
activity_filtered$yr_week <- 52 * (activity_filtered$year - 2017) + activity_filtered$week

# create dummy var to indicate before or after regulation
treatment_date = as.Date("2018-05-25")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$time_treated = activity_filtered$time * activity_filtered$treated

# create interaction term between month and treatment
activity_filtered$month_treated = activity_filtered$month * activity_filtered$treated

# activity_filtered$new_month <- as.factor(activity_filtered$month)
activity_filtered$week_bin <- as.factor(activity_filtered$yr_week)
activity_filtered <- within(activity_filtered, week_bin <- relevel(week_bin, ref = "72"))

activity_filtered$url_bin <- as.factor(activity_filtered$Url)
# activity_filtered <- within(activity_filtered, url_bin <- relevel(url_bin, ref = "google.com"))

#activity_filtered = activity_filtered[activity_filtered$Url != "google.com", ]

# estimate DID estimator
didregyr = lm(log(PageviewsPerMillion) ~ treated + time_treated + week_bin + url_bin,
            data = activity_filtered)

didregyr_pageviewsperuser = lm(log(PageviewsPerUser) ~ treated + time_treated + week_bin + url_bin,
                                  data = activity_filtered)

didregyr_reach = lm(log(ReachPerMillion) ~ treated + time_treated + week_bin + url_bin,
                               data = activity_filtered)

# lmer(didreg, REML = FALSE, data = activity_filtered)

tab_model(didregyr, terms = c("treated", "time_treated"), p.style = "stars")

summary(didregyr)