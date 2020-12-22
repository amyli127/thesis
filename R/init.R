library(data.table)
library(ggplot2)

# read in data
google <- read.csv('python/google_activity_xad.csv', header=TRUE, sep=',')
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "xad")
google_filtered <- google[vars]

# # create subset with just PVD orders
# pvd_orders = subset(master_orders, master_orders$store %in% pvd_stores$X_id)
# 
# # add col with yr-month as value
# setDT(pvd_orders)[, yr_month := format(as.Date(createdAt), "%Y-%m") ]
# 
# # create counts for order data
# activity <- pvd_orders[, .N, by=.(store, yr_month)]
# 
# # bind with column that maps store id to store name
# activity_stores <- merge(x=activity, y=pvd_stores, by.x="store", by.y="X_id", all.x=TRUE)
# 
# create plots
activity_plot = ggplot(google_filtered, aes(Date, PageviewsPerMillion)) +
  geom_point() + geom_line() + ggtitle("Google Pageview Activity") +
  ylab("Pageviews Per Million") + xlab("Date")
plot(activity_plot)
