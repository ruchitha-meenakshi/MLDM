training.dir <- "data/training"
testing.dir <- "data/testing"

library(data.table)

#############################
## function for loading tab-delimited spreadsheets
my.read.table <- function(filename, ...) {
    cat("reading", basename(filename), "... ")
    ## read in tab-delimited spreadsheet
    x <- fread(
        filename,
        header=T,
        stringsAsFactors=F,
        sep="\t",
        ...)
    ## remove any duplicate rows (identified by the first column)
    x <- x[match(unique(x[[1]]), x[[1]]),]
    ## make the first column the rownames of the data frame
    x <- data.frame(x,row.names=1,stringsAsFactors=F)
    cat(nrow(x), "x", ncol(x), "\n")
    x
}

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
protien = dat$protein


save(clinical, methylation, mirna, mrna, mutation, protein)
