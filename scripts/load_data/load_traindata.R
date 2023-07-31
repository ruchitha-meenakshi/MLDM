source("scripts/load_data/load_libraries.R")
source("scripts/load_data/read_table.R")

# setting the training and testing directories path
training.dir <- "../../data/training"

## list all files in the training dataset
filenames <- list.files(training.dir, full.names=T)
print("Printing file names\n")
print(filenames)

## for this example we'll omit CNV
filenames <- filenames[!grepl("cnv", filenames)]

dat.filenames <- filenames[-grep("(example|annotation|targets)", filenames)]

## load the data files into a list
dat <- lapply(dat.filenames, my.read.table)

## name the items of the list by the filename
names(dat) <- sub(".txt", "", basename(dat.filenames))

print(names(dat))

clinical = dat$clinical
methylation = dat$methylation
mirna = dat$mirna
mrna = dat$mrna
mutation = dat$mutation
protein = dat$protein

save(clinical, methylation, mirna, mrna, mutation, protein, file = "RData_files/trainingdata.RData")

