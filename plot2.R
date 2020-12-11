library(data.table)
library(reshape2)
library(png)
library(dplyr)
library(fs)
library(lubridate)
path <- file.path(getwd(), "data/")
fs::dir_create(path = path)

url <-
  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = file.path(path, "dataFiles.zip"), exdir = path)


# Load Electric Power Consumption data
epcDT <-
  data.table::fread(input = "data/household_power_consumption.txt"
                    , na.strings = "?")
epcDT$Date = as.Date(epcDT$Date, format = '%d/%M/%Y')
epcDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

epcDT <-
  filter(epcDT,
         between (epcDT$Date, ymd("2007-02-01"), ymd("2007-02-02")))
# Making a POSIXct dateTime
epcDT$dateTime = as.POSIXct(paste(epcDT$Date, epcDT$Time), format="%Y-%m-%d %H:%M:%S")

png("plot2.png", width = 480, height = 480)
plot(
  x = epcDT[, dateTime]
  ,
  y = epcDT[, Global_active_power]
  ,
  type = "l",
  xlab = "",
  ylab = "Global Active Power (kilowatts)"
)

dev.off()
