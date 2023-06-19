# stats_import.r
# Written by Andrew Harrison (andrew.harrison11@nhs.net) in a personal capacity
# for internal use within the NHS only

# CONFIRM THE COMMON VARIABLES BELOW ARE APPROPRIATE FOR YOUR ENVIRONMENT
# AND THE DATA YOU ARE WORKING WITH

# SET COMMON VARIABLES ----

# set working directory
setwd("c:/b/atp_stats")

# set the date for the first of the month in the spreadsheet you are importing
month_import <- "2023-04-01"

# set the path to the spreadsheet
excel_path <- "raw/2023-04.xlsx"

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
  data.table
)

# IMPORT DATA ----

# Import raw data from Excel
atp_sheet_raw <- read_excel(excel_path, ) 

# MUNGE DATA ----

# Select only the three columns we need
atp_sheet_raw <- subset(atp_sheet_raw, select = c("ODS Code", "Organisation Type", "Server Exposure Score"))

# Change column names
names(atp_sheet_raw)[names(atp_sheet_raw) == "ODS Code"] <- "ods"
names(atp_sheet_raw)[names(atp_sheet_raw) == "Organisation Type"] <- "orgtype"
names(atp_sheet_raw)[names(atp_sheet_raw) == "Server Exposure Score"] <- "cyber_score_server"

# Filter for types of organisations we want
atp_sheet_raw <- atp_sheet_raw %>%
  filter(orgtype=="NHS TRUST")

# Add a new column named 'month' and populate it with the value of month_import
atp_sheet_raw['month']= month_import

# Set 'month' as a date
atp_sheet_raw$month <- as.Date(atp_sheet_raw$month, format = "%Y-%m-%d")

# Rearrange columns so they are in the same order as our existing data
atp_sheet_raw <- subset(atp_sheet_raw, select = c("ods", "month", "cyber_score_server"))

# MERGE DATA ----

# Import existing data
atp_stats_long_import <- readRDS("atp_stats_long_monthbymonth_server.rds")

# Merge the two datasets
atp_stats_long_monthly <- rbind(atp_sheet_raw, atp_stats_long_import)

# Save the resulting dataset back to the monthly file
saveRDS(atp_stats_long_monthly, file = "atp_stats_long_monthbymonth_server.rds")

