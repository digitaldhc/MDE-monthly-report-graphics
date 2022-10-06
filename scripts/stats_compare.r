# stats_compare.r
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
  zoo,
  data.table,
  ggrepel,
  ggthemes,
  ggtext
)

# SET COMMON VARIABLES ----

# Set ODS code for my Trust
my_ods <- "RDY"

# Set ODS codes for comparator Trusts
comparator_1_ods <- "RBD"
comparator_2_ods <- "R0D"
comparator_3_ods <- "RD3"
comparator_4_ods <- "RDZ"

# set working directory, unique to your machine
setwd("c:/b/atp_stats")

# Set plot colours
colour_backgroundorgs <- "seagreen2"
colour_highexposurescore <- "firebrick2"
colour_mediumexposurescore <- "sienna2"
colour_lowexposurescore <- "royalblue3"
colour_my_trust <- "darkorchid4"
colour_comparator_1 <- "green4"
colour_comparator_2 <- "dodgerblue"
colour_comparator_3 <- "navy"
colour_comparator_4 <- "gray20"

# Colours below not used in this script but will retain for consistency
# colour_average <- "black"
# colour_topquartile <- "darkgreen"

# IMPORT DATA ----

# Import monthly data
atp_stats_long_monthly <- readRDS("atp_stats_long_monthbymonth.rds")

# MUNGE DATA ----

# Set the various data strings we'll need
current_month <- head(atp_stats_long_monthly$month, 1) # current month for label plotting
current_month_print <- format(current_month, "%B %Y") # current month for title print
first_month <- tail(atp_stats_long_monthly$month, 1) # first month for label plotting

# CREATE DATA SUBSETS

# My Trust dataset
my_trust <- atp_stats_long_monthly %>% 
  filter(ods==my_ods) 

# Comparator 1 dataset
comparator_1 <- atp_stats_long_monthly %>% 
  filter(ods==comparator_1_ods) 

# Comparator 2 dataset
comparator_2 <- atp_stats_long_monthly %>% 
  filter(ods==comparator_2_ods) 

# Comparator 3 dataset
comparator_3 <- atp_stats_long_monthly %>% 
  filter(ods==comparator_3_ods) 

# Comparator 4 dataset
comparator_4 <- atp_stats_long_monthly %>% 
  filter(ods==comparator_4_ods) 

# NHS Trust average dataset
averages <- atp_stats_long_monthly %>%
  group_by(month) %>%
  summarise(cyber_score_mean = mean(cyber_score, na.rm = TRUE))

# NHS Trust top quartile dataset
topquartile <- atp_stats_long_monthly %>%
  group_by(month) %>%
  summarise(top_quartile = quantile(cyber_score, probs = 0.25, na.rm = TRUE))

# Create latest score variables from these subsets to use in the data plot
latest_my_trust <- head(my_trust$cyber_score, 1)
latest_comparator1 <- head(comparator_1$cyber_score, 1)
latest_comparator2 <- head(comparator_2$cyber_score, 1)
latest_comparator3 <- head(comparator_3$cyber_score, 1)
latest_comparator4 <- head(comparator_4$cyber_score, 1)
# latest_average <- tail(averages$cyber_score_mean, 1)
# latest_quartile <- tail(topquartile$top_quartile, 1)

# Left hand side labels dataset
labels_left_x <- c(first_month, first_month, first_month)
labels_left_y <- c(29, 69, 100)
labels_left_text <- c("Low exposure score", "Medium exposure score", "High exposure score")
labels_left_colour <- c(colour_lowexposurescore, colour_mediumexposurescore, colour_highexposurescore)
plot_labels_left <- data.table(labels_left_x = labels_left_x, labels_left_y = labels_left_y, labels_left_text = labels_left_text, labels_left_colour = labels_left_colour)

# Right hand side labels dataset
labels_right_x <- c(current_month, current_month, current_month, current_month, current_month)
labels_right_y <- c(latest_my_trust, latest_comparator1, latest_comparator2)#, latest_comparator3, latest_comparator4)
labels_right_text <- c(my_ods, comparator_1_ods, comparator_2_ods)#, comparator_3_ods, comparator_4_ods)
labels_right_colour <- c(colour_my_trust, colour_comparator_1, colour_comparator_2)#, colour_comparator_3, colour_comparator_4)
plot_labels_right <- data.table(labels_right_x = labels_right_x, labels_right_y = labels_right_y, labels_right_text = labels_right_text, labels_right_colour = labels_right_colour)

# PLOT DATA ----

# Create the plot
atp_stats_plot <- ggplot() + 
  # background data - commented out but you could turn this on
  # geom_line(data = atp_stats_long_monthly, aes(x = month, y = cyber_score, group = ods, colour = ods), colour = alpha(colour_backgroundorgs, 0.7)) + 
  # average line - commented out but you could turn this on
  # geom_line(data = averages, aes(x = month, y = cyber_score_mean), colour = colour_average, size = 1.5) +
  # Comparator lines
  geom_line(data = comparator_1, aes(x = month, y = cyber_score, group = ods, colour = comparator_1), colour = colour_comparator_1, size = 1) +
  geom_line(data = comparator_2, aes(x = month, y = cyber_score, group = ods, colour = comparator_2), colour = colour_comparator_2, size = 1) +
  # geom_line(data = comparator_3, aes(x = month, y = cyber_score, group = ods, colour = comparator_3), colour = colour_comparator_3, size = 1) +
  # geom_line(data = comparator_4, aes(x = month, y = cyber_score, group = ods, colour = comparator_4), colour = colour_comparator_4, size = 1) +
  # My trust line
  geom_line(data = my_trust, aes(x = month, y = cyber_score, group = ods, colour = my_trust), colour = colour_my_trust, size = 2) +
    # top quartile line - commented out but you could turn this on
  # geom_line(data = topquartile, aes(x = month, y = top_quartile), colour = colour_topquartile, size = 1.5) +
  # exposure score lines
  geom_hline(yintercept = 29, linetype = "dotted", colour = colour_lowexposurescore, size = 2) +
  geom_hline(yintercept = 69, linetype = "dotted", colour = colour_mediumexposurescore, size = 2) +
  geom_hline(yintercept = 100, linetype = "dotted", colour = colour_highexposurescore, size = 2) +
  # left hand side labels
  geom_label(data = plot_labels_left, aes(x = labels_left_x, y = labels_left_y, label = labels_left_text, group = NULL, hjust = "left"), fill = plot_labels_left$labels_left_colour, colour = "white", fontface = "bold", size = 5, nudge_x = 10) +
  # right hand side labels
  geom_text(data = plot_labels_right, aes(x = labels_right_x, y = labels_right_y, label = labels_right_text, group = NULL, hjust = "left"), colour = plot_labels_right$labels_right_colour, fontface = "bold", size = 3, nudge_x = 2.5) +
  # axis settings
  scale_x_date(date_labels = "%b %y", date_breaks = "2 months", expand = expansion(mult = c(0, .08))) +
  scale_y_continuous(breaks = c(20, 40, 60, 80, 100), limits = c(0,100)) +
  # axis labels
  xlab("Month") +
  ylab("Exposure score") +
  # plot title and subtitle
  ggtitle(paste("Cyber exposure scores for Dorset NHS Trusts - January 2020 to", current_month_print, sep = " "), subtitle = "Data supplied by the NHS Digital Data Security Centre") +
  # plot theme
  theme_base() +
  theme(
    axis.text.x = element_text(angle = 00, size = 9),
    plot.title = element_text(size = 20, family = "Arial", face = "bold"),
    plot.subtitle = element_markdown(hjust = 0, vjust = 0, size = 11))

# Draw the plot
atp_stats_plot 

# EXPORT DATA ----

# Export plot png - A4 size
ggsave("atp_stats_comparator.png", width = 33.867, height = 19.05, units = "cm")
