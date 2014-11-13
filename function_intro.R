#Practice assigment for R Programming Assignment 1

getwd()

setwd("C:/Users/angus/Documents/Github/practice_assignment")

#Point and download zip
dataset_url <- "http://s3.amazonaws.com/practice_assignment/diet_data.zip"
download.file(dataset_url, "diet_data.zip")

#use to unzip file
unzip("diet_data.zip", exdir = "diet_data")

#check files i've downloaded
list.files("diet_data")

#read in 1st file
andy <- read.csv("diet_data/Andy.csv")

#quick data exploration
head(andy,10)
length(andy$Day)
#nrows(andy)
dim(andy)

str(andy)
summary(andy)
names(andy)

#now lets look in a bit more detail

andy[1, "Weight"] #row 1 of weight
andy[30, "Weight"] #row 30 of weight

#or rather than base subset on row base on day
andy[which(andy$Day == 30), "Weight"]
andy[which(andy[,"Day"] == 30), "Weight"]
subset(andy$Weight, andy$Day==30)



#Assign the start and end dates to vectors
andy_start <- andy[1, "Weight"]
andy_end <- andy[30, "Weight"]

#use to calculate weight loss
andy_loss <- andy_start - andy_end
andy_loss


#ok now lets think about itterating over all files
#take the old list of files and apply to a variable
files <- list.files("diet_data")
files
class(files) # character list

files[1]
files[3:5]

#try to look at john file
head(read.csv(files[3]))
#can't find file as we're in wrong directory

#use this to append the full list of file names
files_full <- list.files("diet_data", full.names=TRUE)
files_full

head(read.csv(files_full[3]))


#use rbind, rowbind to append 2 files into 1 big one
#note rbind requires and existing dataframe, in this case andy
#you can sometimes create an empty dataframe to start with
andy_david <- rbind(andy, read.csv(files_full[2]))

head(andy_david)
tail(andy_david)

#look at day 25 for both
day_25 <- andy_david[which(andy_david$Day == 25), ]
day_25


#we'll use a loop to append in all files
#quick loop refresh
for (i in 1:5) {print(i)}

#try to bind files
for (i in 1:5) {
  dat <- rbind(dat, read.csv(files_full[i]))
  
#doesn't work because dat doesn't exist yet and rbind needs a starting df

dat <- data.frame()

#now append all files
for (i in 1:5) {
  dat <- rbind(dat, read.csv(files_full[i]))
}
str(dat)
}

#we could try putting the df creation in the loop

for (i in 1:5) {
  dat2 <- data.frame()
  dat2 <- rbind(dat2, read.csv(files_full[i]))
}
str(dat2)

#but what its done is re-written dat2 on each loop
#so you only get the last one

#analyse dat
median(dat$Weight) #returns na
median(dat$Weight, na.rm=TRUE) # deal with nas

#median on day 30
dat_30 <- dat[which(dat[, "Day"] == 30),]
dat_30
median(dat_30$Weight)

#now create a more dynamic function
#where user can select home directory and day to find median
#like this
#weightmedian <- function(directory, day) { # content of the function }


weightmedian <- function(directory, day) {
  files_list <- list.files(directory, full.names=TRUE) #creates a list of files
  dat <- data.frame() #creates an empty data frame
  for (i in 1:5) { #loops through the files, rbinding them together
    dat <- rbind(dat, read.csv(files_list[i]))
  }
  dat_subset <- dat[which(dat[, "Day"] == day),] #subsets the rows that match the 'day' argument
  median(dat_subset[, "Weight"], na.rm=TRUE) #identifies the median weight
  #while stripping out the NAs
}


#now test

weightmedian(directory = "diet_data", day = 20)

#getwd()
#list.files()



