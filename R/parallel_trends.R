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

EU = activity_filtered[!(activity_filtered$Url %in% us_sites$V1), ]
US = activity_filtered[activity_filtered$Url %in% us_sites$V1, ]

agg = aggregate(x = activity_filtered[c("PageviewsPerMillion")],
                by = list(Group.date = activity_filtered$Date, activity_filtered$treated),
                FUN=sum,
                na.rm=TRUE)
agg$Group = ifelse(agg$Group.2 == 0, "US", "EU")
  
  
# 
# graph <- ggplot() +
#   geom_line(data=US, aes(x=Date, y=PageviewsPerMillion)) +
#   geom_line(data=EU, aes(x=Date, y=PageviewsPerMillion)) +
#   # scale_color_manual(values = c("US", "EU" )) +
#   geom_vline(xintercept = as.Date("2018-05-25")) +
#   labs(title="Aggregate Pageviews",
#        x ="Date", y = "Pageviews Per Million") +
#   theme(text=element_text(size=12, family="Times New Roman"))
# 
# plot(graph)


graph <- ggplot(data=agg, aes(x=Group.date, y=PageviewsPerMillion, group=Group.2, color=Group)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2018-05-25")) +
  labs(title="Aggregate Pageviews, US vs EU (2017-2019)",
       x ="Date", y = "Pageviews Per Million") +
  theme(text=element_text(size=12, family="Times New Roman"))

plot(graph)

