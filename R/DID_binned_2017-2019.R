library(foreign)
library(lubridate)
library(ggplot2)
library(broom)
library(dotwhisker)
library(dplyr)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(coefplot)

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

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# create dummy var to indicate before or after regulation
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$time_treated = activity_filtered$time * activity_filtered$treated

# month dummy vars
activity_filtered$jan_2017 <- ifelse(activity_filtered$month == 1 & activity_filtered$year == 2017, 1, 0)
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
activity_filtered$jan2017_treated = activity_filtered$jan_2017 * activity_filtered$treated
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

# activity_filtered = activity_filtered[activity_filtered$Url != "google.com", ]

activity_filtered$url_bin <- as.factor(activity_filtered$Url)

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated  + url_bin +
              jan_2017 + feb_2017 + mar_2017 + apr_2017 + may_2017 + jun_2017 + jul_2017 + aug_2017 + sep_2017 + oct_2017 + nov_2017 + dec_2017 +
              jan_2018 + feb_2018 + mar_2018 + apr_2018 + may_2018 + jun_2018 + jul_2018 + aug_2018 + sep_2018 + oct_2018 + nov_2018 + dec_2018 +
              jan_2019 + feb_2019 + mar_2019 + apr_2019 + may_2019 + jun_2019 + jul_2019 + aug_2019 + sep_2019 + oct_2019 + nov_2019 + dec_2019 +
              jan2017_treated + feb2017_treated + mar2017_treated + apr2017_treated + may2017_treated + jun2017_treated + jul2017_treated + aug2017_treated + sep2017_treated + oct2017_treated + nov2017_treated + dec2017_treated +
              jan2018_treated + feb2018_treated + mar2018_treated + may2018_treated + jun2018_treated + jul2018_treated + aug2018_treated + sep2018_treated + oct2018_treated + nov2018_treated + dec2018_treated +
              jan2019_treated + feb2019_treated + mar2019_treated + apr2019_treated + may2019_treated + jun2019_treated + jul2019_treated + aug2019_treated + sep2019_treated + oct2019_treated + nov2019_treated + dec2019_treated,
            data = activity_filtered)

summary(didreg)

# graph coefficients for pageviews per million
coef <- tidy(didreg)
coef = filter(coef, term %in% c('jan2017_treated', 'feb2017_treated', 'mar2017_treated', 'apr2017_treated', 'may2017_treated', 'jun2017_treated', 'jul2017_treated', 'aug2017_treated', 'sep2017_treated', 'oct2017_treated', 'nov2017_treated', 'dec2017_treated',
                                'jan2018_treated', 'feb2018_treated', 'mar2018_treated', 'apr2018_treated', 'may2018_treated', 'jun2018_treated', 'jul2018_treated', 'aug2018_treated', 'sep2018_treated', 'oct2018_treated', 'nov2018_treated', 'dec2018_treated',
                                'jan2019_treated', 'feb2019_treated', 'mar2019_treated', 'apr2019_treated', 'may2019_treated', 'jun2019_treated', 'jul2019_treated', 'aug2019_treated', 'sep2019_treated', 'oct2019_treated', 'nov2019_treated', 'dec2019_treated'))
graph <- dwplot(coef, labels=c('jan2017'),
       vline = geom_vline(xintercept = -0.070197, colour = "grey60", linetype = 2), horizontal=FALSE) %>% # plot line at zero _behind_ coefs
  relabel_predictors(c(jan2017_treated = "Jan2017",                       
                       feb2017_treated = "Feb2017",
                       mar2017_treated = "Mar2017",
                       apr2017_treated = "Apr2017",
                       may2017_treated = "May2017",
                       jun2017_treated = "Jun2017",
                       jul2017_treated = "Jul2017",
                       aug2017_treated = "Aug2017",
                       sep2017_treated = "Sep2017",
                       oct2017_treated = "Oct2017",
                       nov2017_treated = "Nov2017",
                       dec2017_treated = "Dec2017",
                       jan2018_treated = "Jan2018",                       
                       feb2018_treated = "Fed2018",
                       mar2018_treated = "Mar2018",
                       may2018_treated = "May2018",
                       jun2018_treated = "Jun2018",
                       jul2018_treated = "Jul2018",
                       aug2018_treated = "Aug2018",
                       sep2018_treated = "Sep2018",
                       oct2018_treated = "Oct2018",
                       nov2018_treated = "Nov2018",
                       dec2018_treated = "Dec2018",
                       jan2019_treated = "Jan2019",                       
                       feb2019_treated = "Fed2019",
                       mar2019_treated = "Mar2019",
                       apr2019_treated = "Apr2019",
                       may2019_treated = "May2019",
                       jun2019_treated = "Jun2019",
                       jul2019_treated = "Jul2019",
                       aug2019_treated = "Aug2019",
                       sep2019_treated = "Sep2019",
                       oct2019_treated = "Oct2019",
                       nov2019_treated = "Nov2019",
                       dec2019_treated = "Dec2019")) +
  labs(title="Month by Month GDPR Impact on Pageviews Per Million", x="Coefficient", y="Month") +
  theme(text=element_text(size=12, family="Times New Roman"))

plot(graph)
# 
# 
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

output <- capture.output(
  stargazer(didreg,
            title="Results",
            align=TRUE))
cat(paste(output, collapse = "\n"), "\n", file="table_did_binned", append=FALSE)

# coefplot(didreg, 
#          numberAngle=60,
#          innerCI=FALSE,
#          horizontal=TRUE,
#          ylab="Month",
#          xlab="Interaction Term Coefficient",
#          coefficients=c('jan2017_treated', 'feb2017_treated', 'mar2017_treated', 'apr2017_treated', 'may2017_treated', 'jun2017_treated', 'jul2017_treated', 'aug2017_treated', 'sep2017_treated', 'oct2017_treated', 'nov2017_treated', 'dec2017_treated',
#                                                  'jan2018_treated', 'feb2018_treated', 'mar2018_treated', 'may2018_treated', 'jun2018_treated', 'jul2018_treated', 'aug2018_treated', 'sep2018_treated', 'oct2018_treated', 'nov2018_treated', 'dec2018_treated',
#                                                  'jan2019_treated', 'feb2019_treated', 'mar2019_treated', 'apr2019_treated', 'may2019_treated', 'jun2019_treated', 'jul2019_treated', 'aug2019_treated', 'sep2019_treated', 'oct2019_treated', 'nov2019_treated', 'dec2019_treated'),
#          newNames=c('jan2017_treated', 'feb2017_treated', 'mar2017_treated', 'apr2017_treated', 'may2017_treated', 'jun2017_treated', 'jul2017_treated', 'aug2017_treated', 'sep2017_treated', 'oct2017_treated', 'nov2017_treated', 'dec2017_treated',
#                     'jan2018_treated', 'feb2018_treated', 'mar2018_treated', 'may2018_treated', 'jun2018_treated', 'jul2018_treated', 'aug2018_treated', 'sep2018_treated', 'oct2018_treated', 'nov2018_treated', 'dec2018_treated',
#                     'jan2019_treated', 'feb2019_treated', 'mar2019_treated', 'apr2019_treated', 'may2019_treated', 'jun2019_treated', 'jul2019_treated', 'aug2019_treated', 'sep2019_treated', 'oct2019_treated', 'nov2019_treated', 'dec2019_treated')
# )