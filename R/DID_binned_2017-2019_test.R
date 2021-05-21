library(foreign)
library(lubridate)
library(ggplot2)
library(broom)
library(dotwhisker)
library(dplyr)
library(sjPlot)
library(sjmisc)
library(sjlabelled)

library(stargazer)

# read in data
activity <- read.csv('total-info-2017-2019.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$year <- year(activity_filtered$Date)
activity_filtered$yr_month <- 12 * (activity_filtered$year - 2017) + activity_filtered$month

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# create dummy var to indicate before or after regulation
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# month dummy vars
activity_filtered$month_bin <- as.factor(activity_filtered$yr_month)
activity_filtered <- within(activity_filtered, month_bin <- relevel(month_bin, ref = "16"))

# URL fixed effects
activity_filtered$url_bin <- as.factor(activity_filtered$Url)

# activity_filtered = activity_filtered[activity_filtered$Url != "google.com", ]

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + month_bin + treated*month_bin + url_bin,
             data = activity_filtered)

summary(didreg)

# graph coefficients for pageviews per million
coef <- tidy(didreg)
coef = filter(coef, term %in% c('month_bin1', 'month_bin2', 'month_bin3', 'month_bin4', 'month_bin5', 'month_bin6', 'month_bin7', 'month_bin8', 'month_bin9', 'month_bin10', 'month_bin11', 'month_bin12',
                                'month_bin13', 'month_bin14', 'month_bin15', 'month_bin17', 'month_bin18', 'month_bin19', 'month_bin20', 'month_bin21', 'month_bin22', 'month_bin23', 'month_bin24',
                                'month_bin25', 'month_bin26', 'month_bin27', 'month_bin28', 'month_bin29', 'month_bin30', 'month_bin31', 'month_bin32', 'month_bin32', 'month_bin3034', 'month_bin35', 'month_bin36'))
graph <- dwplot(coef,
       vline = geom_vline(xintercept = -0.062060, colour = "grey60", linetype = 2))


plot(graph)


# tab_model(didreg,
#           terms = c("treated", "time_treated",
#                     'jan2017_treated', 'feb2017_treated', 'mar2017_treated', 'apr2017_treated', 'may2017_treated', 'jun2017_treated', 'jul2017_treated', 'aug2017_treated', 'sep2017_treated', 'oct2017_treated', 'nov2017_treated', 'dec2017_treated',
#                                 'jan2018_treated', 'feb2018_treated', 'mar2018_treated', 'apr2018_treated', 'may2018_treated', 'jun2018_treated', 'jul2018_treated', 'aug2018_treated', 'sep2018_treated', 'oct2018_treated', 'nov2018_treated', 'dec2018_treated',
#                                 'jan2019_treated', 'feb2019_treated', 'mar2019_treated', 'apr2019_treated', 'may2019_treated', 'jun2019_treated', 'jul2019_treated', 'aug2019_treated', 'sep2019_treated', 'oct2019_treated', 'nov2019_treated', 'dec2019_treated'),
#           p.style = "stars",
#           collapse.se = TRUE,
#           show.ci = FALSE,
#           string.pred = "Coeffcient",
#           string.est = "log(PageviewsPerMillion)")
# 
# output <- capture.output(
#   stargazer(didreg,
#             title="Results",
#             align=TRUE))
# cat(paste(output, collapse = "\n"), "\n", file="table_did_binned", append=FALSE)
