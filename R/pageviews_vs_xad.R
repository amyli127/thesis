library(ggplot2)

# read in data
activity <- read.csv('total-info1.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]

p <- ggplot(activity_filtered, aes(x=xad, y=PageviewsPerMillion)) + geom_point() + geom_jitter()
plot(p)