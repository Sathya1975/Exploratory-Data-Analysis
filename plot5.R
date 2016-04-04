##########################################################################################################
## Coursera - Exploratory Data Analysis - Course Project 2

# Course Project
# Sathyanarayanan Shanmugavelu
# 2016-04/04

## plot5.R - generates plot5.png by answering to the following question on exploratory analysis:
#  QUESTION5
#  How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 


# Refs
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

# Output/Results
# 1. plot5.png
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


# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

# 24510 is Baltimore, see plot2.R
# Searching for ON-ROAD type in NEI
subsetNEI <- summarySCC_PM25[summarySCC_PM25$fips=="24510" & summarySCC_PM25$type=="ON-ROAD",  ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEI, sum)

png("plot5.png", width=840, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from motor vehicle (type = ON-ROAD) in Baltimore City, Maryland (fips = "24510") from 1999 to 2008')
print(g)
dev.off()
##########################################################################################################