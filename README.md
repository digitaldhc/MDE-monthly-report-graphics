# MDE-monthly-report-graphics
Using the NHS Digital MDE monthly report spreadsheets to produce data plots that allow you to compare your organisation's performance against others.


# Interpeting NHS cyber exposure scores with R

## Introduction
Have you ever thought about better interpreting the Windows exposure score that gets released every month in the ATP reporting spreadsheets? While you can certainly use Excel to plot this data, it takes a lot of work to collect it in the first place and you can end up with some colossal .xlsx files (we tried it). I spent a good deal of time at home during lockdown learning the statistical programming language R, and wondered if it might have a practical application in interpreting the ATP data. After a bit of work I've ended up with something that might be of use or interest to NHS IT security colleagues.

## Using R and RStudio
Using R and RStudio, you can interpret the Windows Exposure score data to easily plot your position against:
* all other NHS organisations;
* subsets of NHS organisations, for example:
  * NHS Trusts;
  * specific types of Trusts you identify by ODS code;
  * local comparators;
* the national average;
* a best performing quartile.

## Getting started

### Pre-requisites

The easiest way to get going with R is to download R and RStudio from https://www.rstudio.com/products/rstudio/download/#download or request it from your IT team

### Files you'll need

You'll need the scripts here, as well as binary .rds datasets containing the historical security posture data to get you started:

* atp_stats_long_monthbymonth.rds - Windows exposure scores for all NHS Trusts from January 2020-now as an R dataset
* atp_stats_long_monthbymonth_server.rds - Windows exposure scores for all NHS Trusts from May 2021-now as an R dataset
* stats_import.r and stats_import_server.r - import data from an ATP reporting spreadsheet and append it to your existing datasets
* stats_england.r and stats_england_server.r - use the dataset you have downloaded or created to show ATP statistics for your organisation, and compare it against other NHS Trusts in England
* stats_mentalhealthtr.r - compare your organisation against other mental health trusts (useful for us, you could change this to compare other organisations)
* stats_89k.r - compare your organisation against other NHS Trusts that you define
* stats_compare.r - compare your organisation against up to four others with labels

The binary datasets are not published on GitHub but NHS colleagues can obtain them on application by email to andrew.harrison11 (at) nhs.net. If you have the monthly ATP spreadsheets you can in theory compile your own as well.

### Getting started

If you only need NHS trust data, the files I have provided either on GitHub or by email will give you all you need to plot some data, although you will need to keep this up to date either by running the monthly import (covered in the section below) or by downloading atp_stats_long_monthbymonth.rds

### Plotting data

1. Once you have the files, open stats_england.R in RStudio and change the following variables:
	- In **my_ods** set the ODS code for your organisation
	- In **setwd** set an appropriate working directory location on your computer
2. Save your changes to stats_england.r
3. Ensure **atp_stats_long_monthbymonth.rds** is also available in the working directory
4. Run stats_import.r in RStudio by clicking anywhere in the script and pressing **Ctrl + Shift + Enter**
5. If the script runs correctly you should see a data plot appear in RStudio's plots window. The plot should also be saved as atp_stats.png in your working directory.
6. Carry out the same process using stats_england_server.r to plot data for your server fleet.

The other R scripts are mostly variants of these but compare against types of organisations or particular lists of organisations. If you use stats_89k.r you will need to update a manual filter list which can be found in the "create data subsets" section of the script, for stats_compare.r you will need to provide a number of ODS codes to compare against in the variables comparator_1_ods through to comparator_4_ods.

### Carrying out a monthly import

To combine data from a new version of the monthly ATP spreadsheet into the binary dataset files, you will use **stats_import.r** and **stats_import_server.r** to produce up-to-date output data sets you can import into stats_england.r and the other scripts

1. Open stats_import.r in Rstudio and change the following variables:
    - In **setwd** set an appropriate working directory location on your computer
    - In **month_import** set the date for the first of the month in the spreadsheet you are importing, e.g. if you are importing data for June 2021 set this as "2021-06-01" (R does not understand the concept of a month as a unit of time so we need to provide a precise date within the month even though this is not used in the data plots)
    - In **excel_path** specify the name (and relative path under the working directory, if needs be) of the Excel spreadsheet you are importing.
2. Save your changes to stats_import.r
3. Ensure **atp_stats_long_monthbymonth.rds** is also available in the working directory
4. Save the Excel spreadsheet provided by NHS Digital into the location you specified in stats_import.r
5. Run stats_import.r in RStudio by clicking anywhere in the script and pressing **Ctrl + Shift + Enter**
6. if the script runs correctly it should update **atp_stats_long_monthbymonth.rds** in your working directory
7. Repeat the process, using **stats_import_server.r** and **atp_stats_long_monthbymonth_server.rds**

If you want to view the raw data, click on the following data frames in Rstudio's *environment* window:
* **atp_sheet_raw** to view the data imported from the spreadsheet
* **atp_stats_long_import** to view the historical data imported from atp_stats_long_monthbymonth.rds
* **atp_stats_long_monthly** to view the two datasets combined - this has been exported to atp_stats_long_monthbymonth.rds

### Queries

This isn't finished work and I am pleased to discuss it with NHS colleagues or provide best-endeavours support where things aren't working as they should. Please email me - andrew.harrison11 (at) nhs.net or raise an issue.