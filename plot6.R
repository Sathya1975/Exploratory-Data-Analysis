##########################################################################################################
## Coursera - Exploratory Data Analysis - Course Project 2

# Course Project
# Sathyanarayanan Shanmugavelu
# 2016-04/04

## plot6.R - generates plot6.png by answering to the following question on exploratory analysis:
#  QUESTION6
#  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, 
#  California (fips == 06037). Which city has seen greater changes over time in motor vehicle emissions?


# Refs
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

# Output/Results
# 1. plot6.png
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

baltimore4 <- summarySCC_PM25[(summarySCC_PM25$fips=="24510"), ]
baltimore4 <- aggregate(Emissions ~ year, data = baltimore4, FUN = sum)
losangeles <- summarySCC_PM25[(summarySCC_PM25$fips=="06037"),]
losangeles <- aggregate(Emissions ~ year, data = losangeles, FUN = sum)
baltimore4$County <- "Baltimore"
losangeles$County <- "Los Angeles"
ambasciudades <- rbind(baltimore4, losangeles)

fmt <- function(){
  f <- function(x) as.character(round(x,2))
  f
}

png("plot6.png", width = 480, height = 480)
ggplot(ambasciudades, aes(x=factor(year), y=Emissions, fill=County)) +
  geom_bar(aes(fill = County), position = "dodge", stat="identity") +
  labs(x = "Year") + labs(y = expression("Total Emissions (in log scale) of PM"[2.5])) +
  xlab("year") +
  ggtitle(expression("Motor vehicle emission in Baltimore and Los Angeles")) +
  scale_y_continuous(trans = log_trans(), labels = fmt())
dev.off()
##########################################################################################################