library(foreign)
library(lubridate)
library(ggplot2)

# read in data
activity <- read.csv('total-info-2017-2019.csv', header=TRUE, sep=',')
us_sites <- read.csv('sites/us.txt', header=FALSE)

# filter data
vars <- c("Date", "Url", "PageviewsPerMillion", "PageviewsPerUser", "Rank", "ReachPerMillion", "xad", "tic", "revt", "sale")
activity_filtered <- activity[vars]
activity_filtered <- activity_filtered[complete.cases(activity_filtered$xad), ]
activity_filtered$Date <- as.Date(activity_filtered$Date , format = "%Y-%m-%d")
activity_filtered$year <- year(activity_filtered$Date)
activity_filtered$month <- month(activity_filtered$Date)
activity_filtered$day <- day(activity_filtered$Date)
activity_filtered = filter(activity_filtered, month == 5 & day > 7 & day < 29)

# create dummy var to indicate treatment group
activity_filtered$treated = ifelse(activity_filtered$Url %in% us_sites$V1, 0, 1)

# create dummy var for each variable
activity_filtered$day8 <- ifelse(activity_filtered$day == 8, 1, 0)
activity_filtered$day9 <- ifelse(activity_filtered$day == 9, 1, 0)
activity_filtered$day10 <- ifelse(activity_filtered$day == 10, 1, 0)
activity_filtered$day11 <- ifelse(activity_filtered$day == 11, 1, 0)
activity_filtered$day12 <- ifelse(activity_filtered$day == 12, 1, 0)
activity_filtered$day13 <- ifelse(activity_filtered$day == 13, 1, 0)
activity_filtered$day14 <- ifelse(activity_filtered$day == 14, 1, 0)
activity_filtered$day15 <- ifelse(activity_filtered$day == 15, 1, 0)
activity_filtered$day16 <- ifelse(activity_filtered$day == 16, 1, 0)
activity_filtered$day17 <- ifelse(activity_filtered$day == 17, 1, 0)
activity_filtered$day18 <- ifelse(activity_filtered$day == 18, 1, 0)
activity_filtered$day19 <- ifelse(activity_filtered$day == 19, 1, 0)
activity_filtered$day20 <- ifelse(activity_filtered$day == 20, 1, 0)
activity_filtered$day21 <- ifelse(activity_filtered$day == 21, 1, 0)
activity_filtered$day22 <- ifelse(activity_filtered$day == 22, 1, 0)
activity_filtered$day23 <- ifelse(activity_filtered$day == 23, 1, 0)
activity_filtered$day24 <- ifelse(activity_filtered$day == 24, 1, 0)
activity_filtered$day25 <- ifelse(activity_filtered$day == 25, 1, 0)
activity_filtered$day26 <- ifelse(activity_filtered$day == 26, 1, 0)
activity_filtered$day27 <- ifelse(activity_filtered$day == 27, 1, 0)
activity_filtered$day28 <- ifelse(activity_filtered$day == 28, 1, 0)

# create interaction terms between days and treated
activity_filtered$day8_treated = activity_filtered$day8 * activity_filtered$treated
activity_filtered$day9_treated = activity_filtered$day9 * activity_filtered$treated
activity_filtered$day10_treated = activity_filtered$day10 * activity_filtered$treated
activity_filtered$day11_treated = activity_filtered$day11 * activity_filtered$treated
activity_filtered$day12_treated = activity_filtered$day12 * activity_filtered$treated
activity_filtered$day13_treated = activity_filtered$day13 * activity_filtered$treated
activity_filtered$day14_treated = activity_filtered$day14 * activity_filtered$treated
activity_filtered$day15_treated = activity_filtered$day15 * activity_filtered$treated
activity_filtered$day16_treated = activity_filtered$day16 * activity_filtered$treated
activity_filtered$day17_treated = activity_filtered$day17 * activity_filtered$treated
activity_filtered$day18_treated = activity_filtered$day18 * activity_filtered$treated
activity_filtered$day19_treated = activity_filtered$day19 * activity_filtered$treated
activity_filtered$day20_treated = activity_filtered$day20 * activity_filtered$treated
activity_filtered$day21_treated = activity_filtered$day21 * activity_filtered$treated
activity_filtered$day22_treated = activity_filtered$day22 * activity_filtered$treated
activity_filtered$day23_treated = activity_filtered$day23 * activity_filtered$treated
activity_filtered$day24_treated = activity_filtered$day24 * activity_filtered$treated
activity_filtered$day25_treated = activity_filtered$day25 * activity_filtered$treated
activity_filtered$day26_treated = activity_filtered$day26 * activity_filtered$treated
activity_filtered$day27_treated = activity_filtered$day27 * activity_filtered$treated
activity_filtered$day28_treated = activity_filtered$day28 * activity_filtered$treated

# estimate DID estimator
didreg = lm(log(PageviewsPerMillion) ~ treated +
              day8 + day9 + day10 + day11 + day12 + day13 + day14 + day15 + day16 + day17 + day18 + day19 + day20 + day21 + day22 + day23 + day24 + day25 + day26 + day27 + day28 +
              day8_treated + day9_treated + day10_treated + day11_treated + day12_treated + day13_treated + day14_treated + day15_treated + day16_treated + day17_treated + day18_treated + day19_treated + day20_treated + day21_treated + day22_treated + day23_treated + day24_treated + day25_treated + day26_treated + day27_treated + day28_treated,
            data = activity_filtered)
coef <- tidy(didreg)
coef = filter(coef, term %in% c('day8_treated', 'day9_treated', 'day10_treated', 'day12_treated', 'day13_treated', 'day14_treated', 'day15_treated', 'day16_treated', 'day17_treated', 'day18_treated', 'day19_treated', 
                                'day20_treated', 'day21_treated', 'day22_treated', 'day23_treated', 'day24_treated', 'day25_treated', 'day26_treated', 'day27_treated', 'day28_treated'))
graph <- dwplot(coef,
                vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2))
plot(graph)
summary(didreg)