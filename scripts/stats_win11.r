# stats_win11.r
# Script to build NHSD monthly ATP reporting
# Compare up to four other NHS Trusts by ODS code

# INSTALL PACKAGES ----

# Install the pacman package to call all the other packages
if (!require("pacman")) install.packages("pacman")

# Use pacman to install (if req) and load required packages
pacman::p_load(
  readxl,
  tidyr,
  ggplot2,
  dplyr,
  #  zoo,
  data.table,
  ggrepel,
  ggthemes,
  ggtext,
  lubridate,
  scales
)

# SET COMMON VARIABLES ----

# Set ODS code for my Trust
my_ods <- "RDY"

# set working directory, unique to your machine
setwd("c:/b/atp_stats")

# Set path for csv file
csvstats <- "mde_historical_data1.csv"

# Set plot colours
colour_backgroundorgs <- "grey68"
colour_my_trust <- "darkorchid4"
colour_average <- "black"
colour_topquartile <- "darkgreen"

# IMPORT DATA ----

# Import monthly data
# atp_stats_long_monthly <- readRDS("atp_stats_long_monthbymonth_server.rds")
atp_stats_large <- read.csv(csvstats, header = TRUE)

# MUNGE DATA ----

# Set 'month' as a date
atp_stats_large$month <- as.Date(atp_stats_large$month, format = "%Y-%m-%d")

# set strings as integers
atp_stats_large$Windows.11 <- as.integer(atp_stats_large$Windows.11)
atp_stats_large$Active.Windows..30.days. <- as.integer(atp_stats_large$Active.Windows..30.days.)

# constrain data to fourteen months
atp_stats_large <- subset(atp_stats_large, month > today() - months(17))

# filter to nhs trusts
atp_stats_large <- atp_stats_large %>%
  dplyr::filter(Organisation.Type=="NHS TRUST")

# sort data to be newest first
atp_stats_large <- atp_stats_large[order(as.POSIXct(atp_stats_large$month), decreasing = TRUE),]

# calculate win11 percentage
# percentage of active windows 30 days
atp_stats_large$Windows.11.percent <- atp_stats_large$Windows.11 / atp_stats_large$Active.Windows..30.days.

# Set the various data strings we'll need
current_month <- head(atp_stats_large$month, 1) # current month for label plotting
current_month_print <- format(current_month, "%B %Y") # current month for title print
first_month <- tail(atp_stats_large$month, 1) # first month for label plotting
first_month_print <- format(first_month, "%B %Y") # first month for printing

# CREATE DATA SUBSETS

# My Trust dataset
my_trust <- atp_stats_large %>% 
  filter(atp_stats_large$ODS.Code==my_ods) 

# NHS Trust average dataset
averages <- atp_stats_large %>%
  group_by(month) %>%
  summarise(win11_percent_mean = mean(Windows.11.percent, na.rm = TRUE))

# NHS Trust top quartile dataset
topquartile <- atp_stats_large %>%
  group_by(month) %>%
  summarise(win11_percent_tq = quantile(Windows.11.percent, probs = 0.75, na.rm = TRUE))

# Create latest score variables from these subsets to use in the data plot
latest_my_trust <- head(my_trust$Windows.11.percent, 1)
latest_average <- tail(averages$win11_percent_mean, 1)
latest_quartile <- tail(topquartile$win11_percent_tq, 1)

# Right hand side labels dataset
labels_right_x <- c(current_month, current_month, current_month)
labels_right_y <- c(latest_my_trust, latest_average, latest_quartile)
labels_right_text <- c("Dorset\nHealthCare", "Average", "Best quartile")
labels_right_colour <- c(colour_my_trust, colour_average, colour_topquartile)
plot_labels_right <- data.table(labels_right_x = labels_right_x, labels_right_y = labels_right_y, labels_right_text = labels_right_text, labels_right_colour = labels_right_colour)

# PLOT DATA ----
# Create the plot
atp_stats_plot <- ggplot() + 
  # background data - commented out but you could turn this on
  geom_line(data = atp_stats_large, aes(x = month, y = Windows.11.percent, group = ODS.Code, colour = ODS.Code), colour = alpha(colour_backgroundorgs, 0.7)) + 
  # average line
  geom_line(data = averages, aes(x = month, y = win11_percent_mean), colour = colour_average, size = 1.5) +
  # tq line
  geom_line(data = topquartile, aes(x = month, y = win11_percent_tq), colour = colour_topquartile, size = 1.5) +
  # my trust
  geom_line(data = my_trust, aes(x = month, y = Windows.11.percent, group = ODS.Code, colour = my_trust), colour = colour_my_trust, size = 2) +
  # right hand side labels
  geom_text(data = plot_labels_right, aes(x = labels_right_x, y = labels_right_y, label = labels_right_text, group = NULL, hjust = "left"), colour = plot_labels_right$labels_right_colour, fontface = "bold", size = 3, nudge_x = 2.5) +
  # axis settings
  scale_x_date(date_labels = "%b %y", date_breaks = "1 month", expand = expansion(mult = c(0, .08))) +
  scale_y_continuous(labels = scales::percent_format(), position = "right", breaks = seq(0, 2, by = 0.1)) +
  # axis labels
  xlab("Month") +
  ylab("Windows 11 percentage") +
  # plot title and subtitle
  ggtitle(paste("Windows 11 prevalence - NHS Trusts -", first_month_print,"to", current_month_print, sep = " "), subtitle = "Data supplied by the NHS England Cyber Security Operations Centre") +
  # plot theme
  theme_base() +
  theme(
    axis.text.x = element_text(angle = 00, size = 9),
    plot.title = element_text(size = 20, family = "Arial", face = "bold"),
    plot.subtitle = element_markdown(hjust = 0, vjust = 0, size = 11))

#draw plot
atp_stats_plot

# Export plot png - A4 size
ggsave("atp_stats_win11percent.png", width = 33.867, height = 19.05, units = "cm")
