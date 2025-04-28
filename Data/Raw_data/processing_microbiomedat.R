###### Preliminary Data Cleaning Script #########

# Load libraries
library(readxl)  
library(readr)  
library(dplyr)    
library(tidyr)    
library(skimr)    
library(ggplot2)  
library(here)     


# === Load and Save Sheets from Excel ===

input_file <- "41522_2022_345_MOESM1_ESM.xlsx"
sheets <- excel_sheets(input_file)

for (sheet in sheets) {
  excel_data <- read_excel(input_file, sheet = sheet)
  output_file <- paste0("HMPphase1_", gsub(" ", "_", sheet), ".csv")
  write.csv(excel_data, output_file, row.names = FALSE)
}

# === Load the .txt data ===

sample_data <- read_tsv("HMPWgs_Sample.txt")
participant_data <- read_tsv("HMPWgs_Participant.txt")
assay_data <- read_tsv("HMPWgs_Metagenomic_sequencing_assay.txt")
ontology_data <- read_tsv("HMPWgs_ONtologyMetadata.txt")



# === Quick Data Checks ===
# I think I can make this a loop, but I wanted to make sure intially that this runs correctly. 


# --- Sample Data ---
sample_data <- read_tsv("HMPWgs_Sample.txt")
cat("Checking sample_data:\n")
head(sample_data)
tail(sample_data)
glimpse(sample_data)
summary(sample_data)
skim(sample_data)
colSums(is.na(sample_data))   # Missing values check
cat("Basic check for sample_data complete!\n\n")

# --- Participant Data ---
participant_data <- read_tsv("HMPWgs_Participant.txt")
cat("Checking participant_data:\n")
head(participant_data)
tail(participant_data)
glimpse(participant_data)
summary(participant_data)
skim(participant_data)
colSums(is.na(participant_data)) # Missing values check
cat("Basic check for participant_data complete!\n\n")


# --- Ontology Metadata ---
ontology_data <- read_tsv("HMPWgs_OntologyMetadata.txt")
cat("Checking ontology_data:\n")
head(ontology_data)
tail(ontology_data)
glimpse(ontology_data)
summary(ontology_data)
skim(ontology_data)
colSums(is.na(ontology_data)) # Missing values check
cat("Basic check for ontology_data complete!\n\n")


# --- Load the Metagenomic Data ---
metagenomic_data <- read_tsv("HMPWgs_Metagenomic_sequencing_assay.txt")
cat("Checking metagenomic_data:\n")
head(metagenomic_data)
tail(metagenomic_data)
glimpse(metagenomic_data)
summary(metagenomic_data)
# Cannot perform skim it crashes R skim(metagenomic_data)

# Replace NAs with 0 only in numeric columns
metagenomic_data[] <- lapply(metagenomic_data, function(x) {
  if (is.numeric(x)) {
    x[is.na(x)] <- 0
  }
  return(x)
})

# Count the missing values in each column
col_na_counts <- colSums(is.na(metagenomic_data))  
print(col_na_counts)

# Check for columns that are filled with zeros
zero_columns <- colSums(metagenomic_data == 0, na.rm = TRUE)  # Handle NAs while counting zeros

# Print out the names of columns that are entirely zeros
zero_columns_clean <- zero_columns == nrow(metagenomic_data)  # Logical vector indicating columns with all zeros

# Ensure no NA values in the zero_columns_clean (we replace NAs with FALSE)
zero_columns_clean[is.na(zero_columns_clean)] <- FALSE  # Replace NAs with FALSE

# Get the column names that are entirely zeros
zero_column_names <- names(zero_columns_clean)[zero_columns_clean]
print(zero_column_names)

# Remove columns that are entirely zeros
metagenomic_data_cleaned <- metagenomic_data[, !zero_columns_clean]

# Now that we've removed zero columns, recalculate col_na_counts on the cleaned data
col_na_counts_cleaned <- colSums(is.na(metagenomic_data_cleaned))

# Remove columns where more than 50% of the values are missing (adjust threshold if needed)
na_threshold <- 0.5  # Adjust the threshold if needed
valid_columns <- col_na_counts_cleaned < (na_threshold * nrow(metagenomic_data_cleaned))  # Recalculate after cleaning data

# Subset the data to remove columns with too many NAs
metagenomic_data_cleaned <- metagenomic_data_cleaned[, valid_columns]

# Save the cleaned data as .rds files
saveRDS(sample_data, "sample_data_cleaned.rds")
saveRDS(participant_data, "participant_data_cleaned.rds")
saveRDS(ontology_data, "ontology_data_cleaned.rds")
saveRDS(metagenomic_data_cleaned, "metagenomic_data_cleaned.rds")

cat("Data cleaning complete!\n")
cat("Data loaded and cleaned successfully, Pretty Girl!\n")