library(foreign)
library(lubridate)
library(ggplot2)

# read in data
activity <- read.csv('total-info-weighted-2017-2019.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "wxad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$wxad), ]

activity_filtered$Date <- as.Date(activity_filtered$Date, format = "%Y-%m-%d")
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)


activity_filtered = activity_filtered[activity_filtered$Url != "google.com", ]

agg = aggregate(x = activity_filtered[c("PageviewsPerMillion")],
                by = list(Group.date = activity_filtered$Date, activity_filtered$treated),
                FUN=sum,
                na.rm=TRUE)


graph <- ggplot(data=agg, aes(x=Group.date, y=PageviewsPerMillion, group=Group.2)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2018-05-25")) +
  labs(title="Parallel Trends",
       x ="Date", y = "Pageviews Per Million")


# agg = aggregate(x = activity_filtered[c("PageviewsPerMillion")],
#                 by = list(Group.date = activity_filtered$Date, activity_filtered$treated, activity_filtered$Url),
#                 FUN=sum,
#                 na.rm=TRUE)

graph1 <- ggplot(data=activity_filtered, aes(x=Date, y=PageviewsPerMillion, group=Url)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2018-05-25")) +
  labs(title="Parallel Trends",
       x ="Date", y = "Pageviews Per Million")

plot(graph)