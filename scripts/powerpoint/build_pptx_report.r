# build_pptx.r
# Script to build monthly powerpoint reporting deck

# SET WORKING DIRECTORY ----
# set working directory, unique to your machine
setwd("c:/b/atp_stats")

# INSTALL PACKAGES ----

options(repos="https://cran.ma.imperial.ac.uk/")

# Install the pacman package to call all the other packages
if (!require("pacman")) install.packages("pacman")

# Use pacman to install (if req) and load required packages
pacman::p_load(
  tidyverse,
  officer
)

# READ PRESENTATION TEMPLATE ----

pres <- officer::read_pptx("template/test.pptx")

# view the pptx layout properties
# required for testing only
# officer::layout_properties(pres)


# CREATE PRESENTATION CONTENT ----

# presentation title
pres_title <- "Microsoft exposure scores"
# presentation subtitle
pres_sub <- paste("Issued", format(Sys.Date(), "%d %B %Y"), sep = " ")

# create the presentation
my_pres <- pres %>%
  # remove empty first slide
  officer::remove_slide(index = 1) %>%
  # cover slide
  officer::add_slide(layout = "Title Slide", master = "Office Theme") %>%
  officer::ph_with(value = pres_title, location = ph_location_label(ph_label = "Title 1") ) %>%
  officer::ph_with(value = pres_sub, location = ph_location_label(ph_label = "Subtitle 2")) %>%
  # methodology slide
  officer::add_slide(layout = "atp_master_methodology", master = "1_Office Theme") %>%
  officer::ph_with(value = "Methodology", location = ph_location_label(ph_label = "Title 1") ) %>%
  # rap slide
  officer::add_slide(layout = "atp_master_rap", master = "1_Office Theme") %>%
  officer::ph_with(value = "What the process looks like", location = ph_location_label(ph_label = "Title 1") ) %>%
  # exposure score slide
  officer::add_slide(layout = "atp_master_expscore", master = "1_Office Theme") %>%
  officer::ph_with(value = "Exposure score", location = ph_location_label(ph_label = "Title 1") ) %>%
  # atp_stats slide
  officer::add_slide(layout = "Blank", master = "Office Theme") %>%
  officer::ph_with(value = external_img(src = "atp_stats.png", width = 13.333, height = 7.5, unit = "in"), location = ph_location(left = 0, top = 0), use_loc_size = FALSE) %>%
  # atp_stats_server slide
  officer::add_slide(layout = "Blank", master = "Office Theme") %>%
  officer::ph_with(value = external_img(src = "atp_stats_server.png", width = 13.333, height = 7.5, unit = "in"), location = ph_location(left = 0, top = 0), use_loc_size = FALSE) %>%
  # atp_stats_comparator slide
  officer::add_slide(layout = "Blank", master = "Office Theme") %>%
  officer::ph_with(value = external_img(src = "atp_stats_comparator.png", width = 13.333, height = 7.5, unit = "in"), location = ph_location(left = 0, top = 0), use_loc_size = FALSE) %>%
  # atp_stats_comparator_server slide
  officer::add_slide(layout = "Blank", master = "Office Theme") %>%
  officer::ph_with(value = external_img(src = "atp_stats_comparator_server.png", width = 13.333, height = 7.5, unit = "in"), location = ph_location(left = 0, top = 0), use_loc_size = FALSE) %>%
  # atp day-by-day slide
  officer::add_slide(layout = "Blank", master = "Office Theme") %>%
  officer::ph_with(value = external_img(src = "atp_dbd.png", width = 13.333, height = 7.5, unit = "in"), location = ph_location(left = 0, top = 0), use_loc_size = FALSE) %>%
  # lansweeper patch coverage slide
  officer::add_slide(layout = "Blank", master = "Office Theme") %>%
  officer::ph_with(value = external_img(src = "win_patch_coverage.png", width = 13.333, height = 7.5, unit = "in"), location = ph_location(left = 0, top = 0), use_loc_size = FALSE) %>%
  # slg overview slide
  officer::add_slide(layout = "atp_master_square", master = "1_Office Theme") %>%
  officer::ph_with(value = "Exposure scores", location = ph_location_label(ph_label = "Title 1") ) %>%
  officer::ph_with(value = external_img(src = "sq_atp_stats.png", width = 3.748, height = 3.748, unit = "in"), location = ph_location(left = 5.8, top = 0), use_loc_size = FALSE) %>%
  officer::ph_with(value = external_img(src = "sq_atp_stats_server.png", width = 3.748, height = 3.748, unit = "in"), location = ph_location(left = 9.548, top = 0), use_loc_size = FALSE) %>%
  officer::ph_with(value = external_img(src = "sq_atp_stats_comparator.png", width = 3.748, height = 3.748, unit = "in"), location = ph_location(left = 5.8, top = 3.748), use_loc_size = FALSE) %>%
  officer::ph_with(value = external_img(src = "sq_atp_stats_comparator_server.png", width = 3.748, height = 3.748, unit = "in"), location = ph_location(left = 9.548, top = 3.748), use_loc_size = FALSE)

# knit the presentation
print(my_pres, glue::glue("atp_stats.pptx"))
