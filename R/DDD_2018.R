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


# create interactions betw months and treatment
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


# create interactions between spending and each month
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


# create interactions betw treated, spending, and month
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


# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + spending + 
              jan_2018 + feb_2018 + mar_2018 + apr_2018 + may_2018 + jun_2018 + jul_2018 + aug_2018 + sep_2018 + oct_2018 + nov_2018 + dec_2018 +
              treated_spending +
              jan2018_treated + feb2018_treated + mar2018_treated + apr2018_treated + may2018_treated + jun2018_treated + jul2018_treated + aug2018_treated + sep2018_treated + oct2018_treated + nov2018_treated + dec2018_treated +
              jan2018_spending + feb2018_spending + mar2018_spending + apr2018_spending + may2018_spending + jun2018_spending + jul2018_spending + aug2018_spending + sep2018_spending + oct2018_spending + nov2018_spending + dec2018_spending +
              jan2018_spending_treated + feb2018_spending_treated + mar2018_spending_treated + apr2018_spending_treated + may2018_spending_treated + jun2018_spending_treated + jul2018_spending_treated + aug2018_spending_treated + sep2018_spending_treated + oct2018_spending_treated + nov2018_spending_treated + dec2018_spending_treated,
            data = activity_filtered)
summary(didreg)

# graph coefficients
coef <- tidy(didreg)
coef = filter(coef, term %in% c('jan2018_spending_treated', 'feb2018_spending_treated', 'mar2018_spending_treated', 'apr2018_spending_treated', 'may2018_spending_treated', 'jun2018_spending_treated', 'jul2018_spending_treated', 'aug2018_spending_treated', 'sep2018_spending_treated', 'oct2018_spending_treated', 'nov2018_spending_treated', 'dec2018_spending_treated'))
graph <- dwplot(coef,
                vline = geom_vline(xintercept = -0.220132, colour = "grey60", linetype = 2))
plot(graph)
