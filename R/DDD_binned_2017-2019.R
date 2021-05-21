library(foreign)
library(lubridate)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(broom)
library(dotwhisker)
library(broom)
library(dplyr)

library(stargazer)


# read in data
activity <- read.csv('total-info-weighted-2017-2019-new.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "wxad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$wxad), ]

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$year <- year(activity_filtered$Date)

# FILTER OUT JAN 2017 (bc I use it to determine advertising expenditure weights)
cutoff_date = as.Date("2017-01-31")
activity_filtered = activity_filtered[activity_filtered$Date >= cutoff_date, ]

# create dummy var to indicate > or <= median xad
med_xad = median(activity_filtered$wxad)
activity_filtered$spending = ifelse(activity_filtered$wxad <= med_xad, 0, 1)

# create dummy var to indicate before or after treatment
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# interaction term between treated and spending
activity_filtered$treated_spending = activity_filtered$treated * activity_filtered$spending

# month dummy vars
activity_filtered$feb_2017 <- ifelse(activity_filtered$month == 2 & activity_filtered$year == 2017, 1, 0)
activity_filtered$mar_2017 <- ifelse(activity_filtered$month == 3 & activity_filtered$year == 2017, 1, 0)
activity_filtered$apr_2017 <- ifelse(activity_filtered$month == 4 & activity_filtered$year == 2017, 1, 0)
activity_filtered$may_2017 <- ifelse(activity_filtered$month == 5 & activity_filtered$year == 2017, 1, 0)
activity_filtered$jun_2017 <- ifelse(activity_filtered$month == 6 & activity_filtered$year == 2017, 1, 0)
activity_filtered$jul_2017 <- ifelse(activity_filtered$month == 7 & activity_filtered$year == 2017, 1, 0)
activity_filtered$aug_2017 <- ifelse(activity_filtered$month == 8 & activity_filtered$year == 2017, 1, 0)
activity_filtered$sep_2017 <- ifelse(activity_filtered$month == 9 & activity_filtered$year == 2017, 1, 0)
activity_filtered$oct_2017 <- ifelse(activity_filtered$month == 10 & activity_filtered$year == 2017, 1, 0)
activity_filtered$nov_2017 <- ifelse(activity_filtered$month == 11 & activity_filtered$year == 2017, 1, 0)
activity_filtered$dec_2017 <- ifelse(activity_filtered$month == 12 & activity_filtered$year == 2017, 1, 0)

activity_filtered$jan_2018 <- ifelse(activity_filtered$month == 1 & activity_filtered$year == 2018, 1, 0)
activity_filtered$feb_2018 <- ifelse(activity_filtered$month == 2 & activity_filtered$year == 2018, 1, 0)
activity_filtered$mar_2018 <- ifelse(activity_filtered$month == 3 & activity_filtered$year == 2018, 1, 0)
activity_filtered$apr_2018 <- ifelse(activity_filtered$month == 4 & activity_filtered$year == 2018, 1, 0)
activity_filtered$may_2018 <- ifelse(activity_filtered$month == 5 & activity_filtered$year == 2018, 1, 0)
activity_filtered$jun_2018 <- ifelse(activity_filtered$month == 6 & activity_filtered$year == 2018, 1, 0)
activity_filtered$jul_2018 <- ifelse(activity_filtered$month == 7 & activity_filtered$year == 2018, 1, 0)
activity_filtered$aug_2018 <- ifelse(activity_filtered$month == 8 & activity_filtered$year == 2018, 1, 0)
activity_filtered$sep_2018 <- ifelse(activity_filtered$month == 9 & activity_filtered$year == 2018, 1, 0)
activity_filtered$oct_2018 <- ifelse(activity_filtered$month == 10 & activity_filtered$year == 2018, 1, 0)
activity_filtered$nov_2018 <- ifelse(activity_filtered$month == 11 & activity_filtered$year == 2018, 1, 0)
activity_filtered$dec_2018 <- ifelse(activity_filtered$month == 12 & activity_filtered$year == 2018, 1, 0)

activity_filtered$jan_2019 <- ifelse(activity_filtered$month == 1 & activity_filtered$year == 2019, 1, 0)
activity_filtered$feb_2019 <- ifelse(activity_filtered$month == 2 & activity_filtered$year == 2019, 1, 0)
activity_filtered$mar_2019 <- ifelse(activity_filtered$month == 3 & activity_filtered$year == 2019, 1, 0)
activity_filtered$apr_2019 <- ifelse(activity_filtered$month == 4 & activity_filtered$year == 2019, 1, 0)
activity_filtered$may_2019 <- ifelse(activity_filtered$month == 5 & activity_filtered$year == 2019, 1, 0)
activity_filtered$jun_2019 <- ifelse(activity_filtered$month == 6 & activity_filtered$year == 2019, 1, 0)
activity_filtered$jul_2019 <- ifelse(activity_filtered$month == 7 & activity_filtered$year == 2019, 1, 0)
activity_filtered$aug_2019 <- ifelse(activity_filtered$month == 8 & activity_filtered$year == 2019, 1, 0)
activity_filtered$sep_2019 <- ifelse(activity_filtered$month == 9 & activity_filtered$year == 2019, 1, 0)
activity_filtered$oct_2019 <- ifelse(activity_filtered$month == 10 & activity_filtered$year == 2019, 1, 0)
activity_filtered$nov_2019 <- ifelse(activity_filtered$month == 11 & activity_filtered$year == 2019, 1, 0)
activity_filtered$dec_2019 <- ifelse(activity_filtered$month == 12 & activity_filtered$year == 2019, 1, 0)


# create interactions betw months and treatment
activity_filtered$feb2017_treated = activity_filtered$feb_2017 * activity_filtered$treated
activity_filtered$mar2017_treated = activity_filtered$mar_2017 * activity_filtered$treated
activity_filtered$apr2017_treated = activity_filtered$apr_2017 * activity_filtered$treated
activity_filtered$may2017_treated = activity_filtered$may_2017 * activity_filtered$treated
activity_filtered$jun2017_treated = activity_filtered$jun_2017 * activity_filtered$treated
activity_filtered$jul2017_treated = activity_filtered$jul_2017 * activity_filtered$treated
activity_filtered$aug2017_treated = activity_filtered$aug_2017 * activity_filtered$treated
activity_filtered$sep2017_treated = activity_filtered$sep_2017 * activity_filtered$treated
activity_filtered$oct2017_treated = activity_filtered$oct_2017 * activity_filtered$treated
activity_filtered$nov2017_treated = activity_filtered$nov_2017 * activity_filtered$treated
activity_filtered$dec2017_treated = activity_filtered$dec_2017 * activity_filtered$treated

activity_filtered$jan2018_treated = activity_filtered$jan_2018 * activity_filtered$treated
activity_filtered$feb2018_treated = activity_filtered$feb_2018 * activity_filtered$treated
activity_filtered$mar2018_treated = activity_filtered$mar_2018 * activity_filtered$treated
activity_filtered$apr2018_treated = activity_filtered$apr_2018 * activity_filtered$treated
activity_filtered$may2018_treated = activity_filtered$may_2018 * activity_filtered$treated
activity_filtered$jun2018_treated = activity_filtered$jun_2018 * activity_filtered$treated
activity_filtered$jul2018_treated = activity_filtered$jul_2018 * activity_filtered$treated
activity_filtered$aug2018_treated = activity_filtered$aug_2018 * activity_filtered$treated
activity_filtered$sep2018_treated = activity_filtered$sep_2018 * activity_filtered$treated
activity_filtered$oct2018_treated = activity_filtered$oct_2018 * activity_filtered$treated
activity_filtered$nov2018_treated = activity_filtered$nov_2018 * activity_filtered$treated
activity_filtered$dec2018_treated = activity_filtered$dec_2018 * activity_filtered$treated

activity_filtered$jan2019_treated = activity_filtered$jan_2019 * activity_filtered$treated
activity_filtered$feb2019_treated = activity_filtered$feb_2019 * activity_filtered$treated
activity_filtered$mar2019_treated = activity_filtered$mar_2019 * activity_filtered$treated
activity_filtered$apr2019_treated = activity_filtered$apr_2019 * activity_filtered$treated
activity_filtered$may2019_treated = activity_filtered$may_2019 * activity_filtered$treated
activity_filtered$jun2019_treated = activity_filtered$jun_2019 * activity_filtered$treated
activity_filtered$jul2019_treated = activity_filtered$jul_2019 * activity_filtered$treated
activity_filtered$aug2019_treated = activity_filtered$aug_2019 * activity_filtered$treated
activity_filtered$sep2019_treated = activity_filtered$sep_2019 * activity_filtered$treated
activity_filtered$oct2019_treated = activity_filtered$oct_2019 * activity_filtered$treated
activity_filtered$nov2019_treated = activity_filtered$nov_2019 * activity_filtered$treated
activity_filtered$dec2019_treated = activity_filtered$dec_2019 * activity_filtered$treated


# create interactions between spending and each month
activity_filtered$feb2017_spending = activity_filtered$feb_2017 * activity_filtered$spending
activity_filtered$mar2017_spending = activity_filtered$mar_2017 * activity_filtered$spending
activity_filtered$apr2017_spending = activity_filtered$apr_2017 * activity_filtered$spending
activity_filtered$may2017_spending = activity_filtered$may_2017 * activity_filtered$spending
activity_filtered$jun2017_spending = activity_filtered$jun_2017 * activity_filtered$spending
activity_filtered$jul2017_spending = activity_filtered$jul_2017 * activity_filtered$spending
activity_filtered$aug2017_spending = activity_filtered$aug_2017 * activity_filtered$spending
activity_filtered$sep2017_spending = activity_filtered$sep_2017 * activity_filtered$spending
activity_filtered$oct2017_spending = activity_filtered$oct_2017 * activity_filtered$spending
activity_filtered$nov2017_spending = activity_filtered$nov_2017 * activity_filtered$spending
activity_filtered$dec2017_spending = activity_filtered$dec_2017 * activity_filtered$spending

activity_filtered$jan2018_spending = activity_filtered$jan_2018 * activity_filtered$spending
activity_filtered$feb2018_spending = activity_filtered$feb_2018 * activity_filtered$spending
activity_filtered$mar2018_spending = activity_filtered$mar_2018 * activity_filtered$spending
activity_filtered$apr2018_spending = activity_filtered$apr_2018 * activity_filtered$spending
activity_filtered$may2018_spending = activity_filtered$may_2018 * activity_filtered$spending
activity_filtered$jun2018_spending = activity_filtered$jun_2018 * activity_filtered$spending
activity_filtered$jul2018_spending = activity_filtered$jul_2018 * activity_filtered$spending
activity_filtered$aug2018_spending = activity_filtered$aug_2018 * activity_filtered$spending
activity_filtered$sep2018_spending = activity_filtered$sep_2018 * activity_filtered$spending
activity_filtered$oct2018_spending = activity_filtered$oct_2018 * activity_filtered$spending
activity_filtered$nov2018_spending = activity_filtered$nov_2018 * activity_filtered$spending
activity_filtered$dec2018_spending = activity_filtered$dec_2018 * activity_filtered$spending

activity_filtered$jan2019_spending = activity_filtered$jan_2019 * activity_filtered$spending
activity_filtered$feb2019_spending = activity_filtered$feb_2019 * activity_filtered$spending
activity_filtered$mar2019_spending = activity_filtered$mar_2019 * activity_filtered$spending
activity_filtered$apr2019_spending = activity_filtered$apr_2019 * activity_filtered$spending
activity_filtered$may2019_spending = activity_filtered$may_2019 * activity_filtered$spending
activity_filtered$jun2019_spending = activity_filtered$jun_2019 * activity_filtered$spending
activity_filtered$jul2019_spending = activity_filtered$jul_2019 * activity_filtered$spending
activity_filtered$aug2019_spending = activity_filtered$aug_2019 * activity_filtered$spending
activity_filtered$sep2019_spending = activity_filtered$sep_2019 * activity_filtered$spending
activity_filtered$oct2019_spending = activity_filtered$oct_2019 * activity_filtered$spending
activity_filtered$nov2019_spending = activity_filtered$nov_2019 * activity_filtered$spending
activity_filtered$dec2019_spending = activity_filtered$dec_2019 * activity_filtered$spending


# create interactions betw treated, spending, and month
activity_filtered$feb2017_spending_treated = activity_filtered$feb_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$mar2017_spending_treated = activity_filtered$mar_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$apr2017_spending_treated = activity_filtered$apr_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$may2017_spending_treated = activity_filtered$may_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$jun2017_spending_treated = activity_filtered$jun_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$jul2017_spending_treated = activity_filtered$jul_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$aug2017_spending_treated = activity_filtered$aug_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$sep2017_spending_treated = activity_filtered$sep_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$oct2017_spending_treated = activity_filtered$oct_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$nov2017_spending_treated = activity_filtered$nov_2017 * activity_filtered$spending * activity_filtered$treated
activity_filtered$dec2017_spending_treated = activity_filtered$dec_2017 * activity_filtered$spending * activity_filtered$treated

activity_filtered$jan2018_spending_treated = activity_filtered$jan_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$feb2018_spending_treated = activity_filtered$feb_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$mar2018_spending_treated = activity_filtered$mar_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$apr2018_spending_treated = activity_filtered$apr_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$may2018_spending_treated = activity_filtered$may_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$jun2018_spending_treated = activity_filtered$jun_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$jul2018_spending_treated = activity_filtered$jul_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$aug2018_spending_treated = activity_filtered$aug_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$sep2018_spending_treated = activity_filtered$sep_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$oct2018_spending_treated = activity_filtered$oct_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$nov2018_spending_treated = activity_filtered$nov_2018 * activity_filtered$spending * activity_filtered$treated
activity_filtered$dec2018_spending_treated = activity_filtered$dec_2018 * activity_filtered$spending * activity_filtered$treated

activity_filtered$jan2019_spending_treated = activity_filtered$jan_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$feb2019_spending_treated = activity_filtered$feb_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$mar2019_spending_treated = activity_filtered$mar_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$apr2019_spending_treated = activity_filtered$apr_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$may2019_spending_treated = activity_filtered$may_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$jun2019_spending_treated = activity_filtered$jun_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$jul2019_spending_treated = activity_filtered$jul_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$aug2019_spending_treated = activity_filtered$aug_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$sep2019_spending_treated = activity_filtered$sep_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$oct2019_spending_treated = activity_filtered$oct_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$nov2019_spending_treated = activity_filtered$nov_2019 * activity_filtered$spending * activity_filtered$treated
activity_filtered$dec2019_spending_treated = activity_filtered$dec_2019 * activity_filtered$spending * activity_filtered$treated

# activity_filtered = activity_filtered[activity_filtered$Url != "google.com", ]

# URL fixed effects
activity_filtered$url_bin <- as.factor(activity_filtered$Url)

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + spending + url_bin +
              feb_2017 + mar_2017 + apr_2017 + may_2017 + jun_2017 + jul_2017 + aug_2017 + sep_2017 + oct_2017 + nov_2017 + dec_2017 +
              jan_2018 + feb_2018 + mar_2018 + may_2018 + jun_2018 + jul_2018 + aug_2018 + sep_2018 + oct_2018 + nov_2018 + dec_2018 +
              jan_2019 + feb_2019 + mar_2019 + apr_2019 + may_2019 + jun_2019 + jul_2019 + aug_2019 + sep_2019 + oct_2019 + nov_2019 + dec_2019 +
              treated_spending +
              feb2017_treated + mar2017_treated + apr2017_treated + may2017_treated + jun2017_treated + jul2017_treated + aug2017_treated + sep2017_treated + oct2017_treated + nov2017_treated + dec2017_treated +
              jan2018_treated + feb2018_treated + mar2018_treated + may2018_treated + jun2018_treated + jul2018_treated + aug2018_treated + sep2018_treated + oct2018_treated + nov2018_treated + dec2018_treated +
              jan2019_treated + feb2019_treated + mar2019_treated + apr2019_treated + may2019_treated + jun2019_treated + jul2019_treated + aug2019_treated + sep2019_treated + oct2019_treated + nov2019_treated + dec2019_treated +
              feb2017_spending + mar2017_spending + apr2017_spending + may2017_spending + jun2017_spending + jul2017_spending + aug2017_spending + sep2017_spending + oct2017_spending + nov2017_spending + dec2017_spending +
              jan2018_spending + feb2018_spending + mar2018_spending + may2018_spending + jun2018_spending + jul2018_spending + aug2018_spending + sep2018_spending + oct2018_spending + nov2018_spending + dec2018_spending +
              jan2019_spending + feb2019_spending + mar2019_spending + apr2019_spending + may2019_spending + jun2019_spending + jul2019_spending + aug2019_spending + sep2019_spending + oct2019_spending + nov2019_spending + dec2019_spending +
              feb2017_spending_treated + mar2017_spending_treated + apr2017_spending_treated + may2017_spending_treated + jun2017_spending_treated + jul2017_spending_treated + aug2017_spending_treated + sep2017_spending_treated + oct2017_spending_treated + nov2017_spending_treated + dec2017_spending_treated +
              jan2018_spending_treated + feb2018_spending_treated + mar2018_spending_treated + may2018_spending_treated + jun2018_spending_treated + jul2018_spending_treated + aug2018_spending_treated + sep2018_spending_treated + oct2018_spending_treated + nov2018_spending_treated + dec2018_spending_treated +
              jan2019_spending_treated + feb2019_spending_treated + mar2019_spending_treated + apr2019_spending_treated + may2019_spending_treated + jun2019_spending_treated + jul2019_spending_treated + aug2019_spending_treated + sep2019_spending_treated + oct2019_spending_treated + nov2019_spending_treated + dec2019_spending_treated,
            data = activity_filtered)
summary(didreg)

# graph coefficients
coef <- tidy(didreg)
coef = filter(coef, term %in% c('feb2017_spending_treated', 'mar2017_spending_treated', 'apr2017_spending_treated', 'may2017_spending_treated', 'jun2017_spending_treated', 'jul2017_spending_treated', 'aug2017_spending_treated', 'sep2017_spending_treated', 'oct2017_spending_treated', 'nov2017_spending_treated', 'dec2017_spending_treated',
                                'jan2018_spending_treated', 'feb2018_spending_treated', 'mar2018_spending_treated', 'may2018_spending_treated', 'jun2018_spending_treated', 'jul2018_spending_treated', 'aug2018_spending_treated', 'sep2018_spending_treated', 'oct2018_spending_treated', 'nov2018_spending_treated', 'dec2018_spending_treated',
                                'jan2019_spending_treated', 'feb2019_spending_treated', 'mar2019_spending_treated', 'apr2019_spending_treated', 'may2019_spending_treated', 'jun2019_spending_treated', 'jul2019_spending_treated', 'aug2019_spending_treated', 'sep2019_spending_treated', 'oct2019_spending_treated', 'nov2019_spending_treated', 'dec2019_spending_treated'))

graph <- dwplot(coef, labels=c('jan2017'),
                vline = geom_vline(xintercept = 0.049345, colour = "grey60", linetype = 2), horizontal=FALSE) %>% # plot line at zero _behind_ coefs
  relabel_predictors(c(jan2017_spending_treated = "Jan2017",                       
                       feb2017_spending_treated = "Feb2017",
                       mar2017_spending_treated = "Mar2017",
                       apr2017_spending_treated = "Apr2017",
                       may2017_spending_treated = "May2017",
                       jun2017_spending_treated = "Jun2017",
                       jul2017_spending_treated = "Jul2017",
                       aug2017_spending_treated = "Aug2017",
                       sep2017_spending_treated = "Sep2017",
                       oct2017_spending_treated = "Oct2017",
                       nov2017_spending_treated = "Nov2017",
                       dec2017_spending_treated = "Dec2017",
                       jan2018_spending_treated = "Jan2018",                       
                       feb2018_spending_treated = "Fed2018",
                       mar2018_spending_treated = "Mar2018",
                       may2018_spending_treated = "May2018",
                       jun2018_spending_treated = "Jun2018",
                       jul2018_spending_treated = "Jul2018",
                       aug2018_spending_treated = "Aug2018",
                       sep2018_spending_treated = "Sep2018",
                       oct2018_spending_treated = "Oct2018",
                       nov2018_spending_treated = "Nov2018",
                       dec2018_spending_treated = "Dec2018",
                       jan2019_spending_treated = "Jan2019",                       
                       feb2019_spending_treated = "Fed2019",
                       mar2019_spending_treated = "Mar2019",
                       apr2019_spending_treated = "Apr2019",
                       may2019_spending_treated = "May2019",
                       jun2019_spending_treated = "Jun2019",
                       jul2019_spending_treated = "Jul2019",
                       aug2019_spending_treated = "Aug2019",
                       sep2019_spending_treated = "Sep2019",
                       oct2019_spending_treated = "Oct2019",
                       nov2019_spending_treated = "Nov2019",
                       dec2019_spending_treated = "Dec2019")) +
  labs(title="Month by Month GDPR Impact on Pageviews Per Million According to Advertising Expenditure", x="Coefficient", y="Month") +
  theme(text=element_text(size=12, family="Times New Roman"))

plot(graph)
# 
# output <- capture.output(
#   stargazer(didreg,
#             title="Results",
#             align=TRUE))
# cat(paste(output, collapse = "\n"), "\n", file="table_ddd_binned", append=FALSE)