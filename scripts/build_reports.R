# build_reports.R
# build all reporting

setwd("c:/github/MDE-monthly-report-graphics/scripts")

# RECTANGULAR PLOTS ----
source("stats_england.r")

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("stats_england_server.r")

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("stats_89k.r")

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("stats_compare_server.r")

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("stats_compare.r")

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("stats_mentalhealthtr.r")

remove(list=ls())

# SQUARE PLOTS ----
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("square_plots/stats_compare_server_sq.r", chdir = T)

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("square_plots/stats_compare_sq.r", chdir = T)

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("square_plots/stats_england_server_sq.r", chdir = T)

remove(list=ls())
setwd("c:/github/MDE-monthly-report-graphics/scripts")
source("square_plots/stats_england_sq.r", chdir = T)

remove(list=ls())
