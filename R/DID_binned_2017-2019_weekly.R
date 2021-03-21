library(foreign)
library(lubridate)
library(ggplot2)
library(broom)
library(dotwhisker)
library(dplyr)

# read in data
activity <- read.csv('total-info-2017-2019.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$year <- year(activity_filtered$Date)
activity_filtered$week <- week(activity_filtered$Date)
activity_filtered$yr_week <- 52 * (activity_filtered$year - 2017) + activity_filtered$week
activity_filtered$yr_month <- 12 * (activity_filtered$year - 2017) + activity_filtered$month

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
activity_filtered$week_bin <- as.factor(activity_filtered$yr_week)
activity_filtered$month_bin <- as.factor(activity_filtered$yr_month)

activity_filtered <- within(activity_filtered, week_bin <- relevel(week_bin, ref = "72"))
activity_filtered <- within(activity_filtered, month_bin <- relevel(month_bin, ref = "17"))


# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + week_bin + week_bin * treated,
            data = activity_filtered)
summary(didreg)

# graph coefficients
coef <- tidy(didreg)
coef = filter(coef, !(term %in% c('week_bin1', 'week_bin2', 'week_bin3', 'week_bin4', 'week_bin5', 'week_bin6', 'week_bin7', 'week_bin8', 'week_bin9',
                                  'week_bin10', 'week_bin11', 'week_bin12', 'week_bin13', 'week_bin14', 'week_bin15', 'week_bin16', 'week_bin17', 'week_bin18', 'week_bin19',
                                  'week_bin20', 'week_bin21', 'week_bin22', 'week_bin23', 'week_bin24', 'week_bin25', 'week_bin26', 'week_bin27', 'week_bin28', 'week_bin29',
                                  'week_bin30', 'week_bin31', 'week_bin32', 'week_bin33', 'week_bin34', 'week_bin35', 'week_bin36', 'week_bin37', 'week_bin38', 'week_bin39',
                                  'week_bin40', 'week_bin41', 'week_bin42', 'week_bin43', 'week_bin44', 'week_bin45', 'week_bin46', 'week_bin47', 'week_bin48', 'week_bin49',
                                  'week_bin50', 'week_bin51', 'week_bin52', 'week_bin53', 'week_bin54', 'week_bin55', 'week_bin56', 'week_bin57', 'week_bin58', 'week_bin59',
                                  'week_bin60', 'week_bin61', 'week_bin62', 'week_bin63', 'week_bin64', 'week_bin65', 'week_bin66', 'week_bin67', 'week_bin68', 'week_bin69',
                                  'week_bin70', 'week_bin71', 'week_bin72', 'week_bin73', 'week_bin74', 'week_bin75', 'week_bin76', 'week_bin77', 'week_bin78', 'week_bin79',
                                  'week_bin80', 'week_bin81', 'week_bin82', 'week_bin83', 'week_bin84', 'week_bin85', 'week_bin86', 'week_bin87', 'week_bin88', 'week_bin89',
                                  'week_bin90', 'week_bin91', 'week_bin92', 'week_bin93', 'week_bin94', 'week_bin95', 'week_bin96', 'week_bin97', 'week_bin98', 'week_bin99',
                                  'week_bin100', 'week_bin101', 'week_bin102', 'week_bin103', 'week_bin104', 'week_bin105', 'week_bin106', 'week_bin107', 'week_bin108', 'week_bin109',
                                  'week_bin110', 'week_bin111', 'week_bin112', 'week_bin113', 'week_bin114', 'week_bin115', 'week_bin116', 'week_bin117', 'week_bin118', 'week_bin119',
                                  'week_bin120', 'week_bin121', 'week_bin122', 'week_bin123', 'week_bin124', 'week_bin125', 'week_bin126', 'week_bin127', 'week_bin128', 'week_bin129',
                                  'week_bin130', 'week_bin131', 'week_bin132', 'week_bin133', 'week_bin134', 'week_bin135', 'week_bin136', 'week_bin137', 'week_bin138', 'week_bin139',
                                  'week_bin140', 'week_bin141', 'week_bin142', 'week_bin143', 'week_bin144', 'week_bin145', 'week_bin146', 'week_bin147', 'week_bin148', 'week_bin149',
                                  'week_bin150', 'week_bin151', 'week_bin152', 'week_bin153', 'week_bin154', 'week_bin155', 'week_bin156', 'week_bin157')))
graph <- dwplot(coef,
                vline = geom_vline(xintercept = 0.0319447, colour = "grey60", linetype = 2))
plot(graph)
