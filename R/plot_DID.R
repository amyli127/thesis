library(foreign)
library(ggplot2)
library(dplyr)

# read in data
activity <- read.csv('total-info1.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]

# change date field to a date object
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")

# create dummy var to indicate before or after treatment
treatment_date = as.Date("2018-05-18")
activity_filtered$time = ifelse(activity_filtered$Date < treatment_date, 0, 1)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create interaction term between time and treated
activity_filtered$did = activity_filtered$time * activity_filtered$treated


##### plot DID #######

# get summary data for group averages
activity_filtered %>% 
  group_by(Date,treated) %>% 
  summarize(PageviewsPerMillion=mean(PageviewsPerMillion)) -> sumdata

# create plot
dd <- 
  ggplot() + geom_line(data=activity_filtered,aes(x=Date,y=PageviewsPerMillion,group=treated,color=treated),
                     size=1,alpha=0.25) + # plot the individual lines
  geom_line(data=sumdata,aes(x=Date,y=PageviewsPerMillion,group=treated,color=treated),
            size=2) + # plot the averages for each group
  geom_vline(xintercept = 2018-05-18) + # intervention point
  scale_color_manual(values=c("red","blue"), # label our groups
                     labels=c("Control Average","Treatment Average")) +
  labs(title="Difference in Differences",
       x="Time",
       y="Outcome") +
  theme_minimal()

plot(dd)


