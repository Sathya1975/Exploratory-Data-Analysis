##########################################################################################################
## Coursera - Exploratory Data Analysis - Course Project 2

# Course Project
# Sathyanarayanan Shanmugavelu
# 2016-04/04

## plot4.R - generates plot4.png by answering to the following question on exploratory analysis:
#  QUESTION4
#  Across the United States, how have emissions from coal combustion-related sources changed from 1999Ð2008?

# Refs
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

# Output/Results
# 1. plot4.png
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

# Coal combustion related sources
SCC.coal = Source_Classification_Code[grepl("coal", Source_Classification_Code$Short.Name, ignore.case=TRUE),]

# Merge two data sets
NEISCC  <- merge(x=summarySCC_PM25, y=SCC.coal, by='SCC')

# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

# fetch all NEIxSCC records with Short.Name (SCC) Coal
coalMatches  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
subsetNEISCC <- NEISCC[coalMatches, ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEISCC, sum)


png("plot4.png", width=640, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from coal sources from 1999 to 2008')
print(g)
dev.off()
##########################################################################################################