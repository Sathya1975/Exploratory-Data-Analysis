##########################################################################################################
## Coursera - Exploratory Data Analysis - Course Project 2

# Course Project
# Sathyanarayanan Shanmugavelu
# 2016-04/04

## plot3.R - generates plot3.png by answering to the following question on exploratory analysis:
#  QUESTION3
#  Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources 
#  have seen decreases in emissions from 1999Ð2008 for Baltimore City? Which have seen increases in emissions from 1999Ð2008? 
#  Use the ggplot2 plotting system to make a plot answer this question.

# Refs
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

# Output/Results
# 1. plot3.png
##########################################################################################################


## First of all, we make sure we have the downloaded data available, we will
## put it in a file in the local working directory
filename = "exdata-data-NEI_data.zip"
if (!file.exists(filename)) {
  retval = download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                         destfile = filename)
}

# Cleanup 
rm(list = ls())

# Fetch and unzip the data set
baseDir <- "."

# Create data sub-directory if necessary
dataDir <- paste(baseDir, "data", sep="/")
if(!file.exists(dataDir)) {
  dir.create(dataDir)
}

# Download original data if necessary (skip if exists already as it takes time)
zipFilePath <- paste(dataDir, "exdata-data-NEI_data.zip", sep="/")
if (!file.exists(zipFilePath)) {
  zipFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file (zipFileUrl, zipFilePath)
  dateDownloaded <- date()
  cat ("Dataset downloaded on:", dateDownloaded,"\n")
}

# Unzip and creates dataSetDir if necessary
dataSetDir <-  paste (baseDir, "PM2.5 Emissions Data", sep="/")
if (!file.exists(dataSetDir)) {
  unzip (zipFilePath, exdir=baseDir)
}
list.files(baseDir)


## Load all the libraries that are needed for the data reading and plotting
library(plyr)
library(ggplot2)
library(data.table)
library(grid)
library(scales)
library(httr) 


Source_Classification_Code <- readRDS("Source_Classification_Code.rds")
summarySCC_PM25 <- readRDS("summarySCC_PM25.rds")

baltimore <- summarySCC_PM25[which(summarySCC_PM25$fips == "24510"), ]
baltimore3 <- ddply(baltimore, .(type, year), summarize, Emissions = sum(Emissions))

png("plot3.png", width = 480, height = 480)
qplot(year, Emissions, data = baltimore3, group = type, 
      color = type, geom = c("point", "line"), ylab = expression("Total Emissions of PM"[2.5]), 
      xlab = "Year", main = "Total Emissions in U.S. by Type of Pollutant")
dev.off()
##########################################################################################################