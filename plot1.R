##########################################################################################################
## Coursera - Exploratory Data Analysis - Course Project 2

# Course Project
# Sathyanarayanan Shanmugavelu
# 2016-04/04

## plot1.R - generates plot1.png by answering to the following question on exploratory analysis:
#  QUESTION1
#  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, 
#  make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
#  Upload a PNG file containing your plot addressing this question.

# Refs
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

# Output/Results
# 1. plot1.png
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

clasificacion = data.table(Source_Classification_Code)
summarySCC_PM25 = data.table(summarySCC_PM25)

PM_Contamination <- with(summarySCC_PM25, aggregate(Emissions, by = list(year), sum))

png("plot1.png", width = 480, height = 480)
plot(PM_Contamination, type = "b", pch = 25, col = "blue", ylab = "Emissions", xlab = "Year", main = "Annual Emissions")
dev.off()
##########################################################################################################