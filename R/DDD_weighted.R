library(foreign)

# read in data
activity <- read.csv('total-info-weighted2.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "wxad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$wxad), ]

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# create dummy var to indicate > or <= median xad
med_xad = median(activity_filtered$wxad)
#mean_xad = mean(activity_filtered$xad)
#quantiles = quantile(activity_filtered$xad, c(0.25, 0.75))
#twentyfifth_percentile = quantiles[[1]]
activity_filtered$spending = ifelse(activity_filtered$wxad <= med_xad, 0, 1)

# create dummy var to indicate before or after treatment
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$did = activity_filtered$time * activity_filtered$treated

# create interaction term between the time and spending
activity_filtered$did1 = activity_filtered$time * activity_filtered$spending

# create interaction term between spending and treated
activity_filtered$did2 = activity_filtered$spending * activity_filtered$treated

# create interaction term between time, treated, and spending
activity_filtered$did3 = activity_filtered$time * activity_filtered$treated * activity_filtered$spending

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated + time + spending + 
              did + did1 + did2 + did3,
            data = activity_filtered)
summary(didreg)
