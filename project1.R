library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library(dummies)
library(tibble)

refine_original <- read_csv("C:/Users/heath/Desktop/springboard coursework/refine_original.csv")
View(refine_original)

#convert data to data frame

refine_original <- as.data.frame(refine_original)

#change company names to all lowercase letters

refine_original$company <- tolower(refine_original$company)

#Correct misspellings in company names to philips, akzo, van houten, and unilever

refine_original$company <- gsub("^p.*", "philips", refine_original$company)
refine_original$company <- gsub("^f.*", "philips", refine_original$company)
refine_original$company <- gsub("^a.*", "akzo", refine_original$company)
refine_original$company <- gsub("^v.*", "van houten", refine_original$company)
refine_original$company <- gsub("^u.*", "unilever", refine_original$company)

#separate "product code/number" column into two columns (product_code, product_number)

refined_data <- separate(refine_original, "Product code / number", c("product_code", "product_number"), sep = "-")

#identify product symbols as Smartphone, TV, Laptop, or Tablet. Create a column to reflect this new information

index <- c("p", "x", "v", "q")
values <- c("Smartphone", "TV", "Laptop", "Tablet")
refined_data$product_categories <- values[match(refined_data$product_code, index)]

#Combine address columns into one column labelled "Full_address" (address, city, country)

refined_data <- unite(refined_data, "full_address", c(address, city, country), sep = ", ")

#Add binary dummy columns to reflect companies and product categories

refined_data <- cbind(refined_data, dummy(refined_data$company, sep = "_"))

refined_data <- cbind(refined_data, dummy(refined_data$product_categories, sep = "_"))

refined_data

write_excel_csv(refined_data, path = "refine_clean.csv", na = "NA", append = FALSE)
