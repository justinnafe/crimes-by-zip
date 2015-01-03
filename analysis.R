library(lubridate)
library(dplyr)

#' Get the crime data from dallasopendata.com
crime.data.file <- "crime.csv"
if(!file.exists(crime.data.file)){
  download.file("http://www.dallasopendata.com/api/views/ftja-9jxd/rows.csv?accessType=DOWNLOAD",
                destfile=crime.data.file)
}

#' Disclaimer: The data supplied by Dallas Police Department is sampled
#' and should not be used for statistical purposes, but we should be able to 
#' extract enough informaation to get a general idea of where crime is concentrated
#' 
#' The Dallas Police Department implemented a new Records Management System
#' on June 1, 2014. To get crime data for 2014, two datasets are needed.
rms.file <- "rms.csv"
if(!file.exists(rms.file)){
  download.file("http://www.dallasopendata.com/api/views/tbnj-w5hb/rows.csv?accessType=DOWNLOAD",
                destfile=rms.file)
}


#' Read in the crime data into a data.frame
crime.data.part1 <- read.csv(crime.data.file,
                       as.is = TRUE)
crime.data.part2 <- read.csv(rms.file,
                             as.is = TRUE)

#' Get the columns that are needed for this analysis, 
#' change names if necessary, remove records from
#' the rms data if necessary, and then bind the two sets by rows. 
crime.data <- dplyr::select(crime.data.part1, offensedate, offensetimedispatched, offensezip)
temp <- dplyr::select(crime.data.part2, Date1, Time1, ZipCode)

colnames(temp) <- c("offensedate", "offensetimedispatched", "offensezip")
temp <- mutate(temp, tempdate = as.Date(temp$offensedate,
                                        format="%m/%d/%Y"))

temp <- temp[as.Date(temp$tempdate) >= as.Date("2014-06-01") 
             & year(temp$tempdate) == 2014 
             & !is.na(temp$tempdate),]

#' Remove the tempdate column
tempdateindex <- grep("^tempdate$", colnames(temp))
temp <- temp[,-tempdateindex]

#' Bind the two data sets
crime.data <- rbind(crime.data, temp)

#' Check our date range of the data
crime.data$offensedate <- as.Date(crime.data$offensedate,
    format="%m/%d/%Y")

paste("Min is ", min(crime.data$offensedate), sep=" ")
paste("Max is ", max(crime.data$offensedate), sep=" ")

#' Check if the data is what is expected
crime.data <- mutate(crime.data, offenseyear = year(crime.data$offensedate))

crime <- group_by(crime.data, offenseyear)
summarize(crime, countsperyear = length(offenseyear))

#' The most observations happen in 2014, so it appears that data is not 
#' available for other years
#' 
#' Get data for 2014
crime.data <- crime.data[crime.data$offenseyear == 2014,]

#' Check the distribution per month
crime.data <- mutate(crime.data, offensemonth = month(crime.data$offensedate))
crime.data.month <- group_by(crime.data, offensemonth)
summarize(crime.data.month, countspermonth = length(offensemonth))

#' For 2014, what are the zip codes with the most crimes?
#' 
#' I was able to get the dallas zip codes and lat longs of the zip codes
#' from http://www.unitedstateszipcodes.org/
dallas.zips <- read.csv("zip_code_database.csv")
zip.index <- grep("^offensezip$", colnames(crime.data))
colnames(crime.data)[zip.index] <- "zip"
merged.data <- merge(crime.data, dallas.zips, by = "zip")

crime.data.zip <- group_by(merged.data, zip)
summary <- summarise(crime.data.zip,  
          countsperzip = length(zip) )

head(arrange(summary, desc(countsperzip)))
