###### Preliminary Data Cleaning Script #########

# === Load Required Libraries ===
library(tidyverse)
library(skimr)

# === Load the .txt data using relative paths ===
sample_data <- read_tsv("../../Data/Raw_data/Human_Microbiome_CleanUp/HMPWgs_Sample.txt")
participant_data <- read_tsv("../../Data/Raw_data/Human_Microbiome_CleanUp/HMPWgs_Participant.txt")
assay_data <- read_tsv("../../Data/Raw_data/Human_Microbiome_CleanUp/HMPWgs_Metagenomic_sequencing_assay.txt")
ontology_data <- read_tsv("../../Data/Raw_data/Human_Microbiome_CleanUp/HMPWgs_OntologyMetadata.txt")

# === Quick Data Checks: Loop through datasets ===
data_list <- list(
  sample_data = sample_data,
  participant_data = participant_data,
  ontology_data = ontology_data
)

for (name in names(data_list)) {
  cat(paste("Checking", name, ":\n"))
  data <- data_list[[name]]
  print(head(data))
  print(tail(data))
  glimpse(data)
  print(summary(data))
  skim(data)
  print(colSums(is.na(data)))  # Missing values check
  cat(paste("Basic check for", name, "complete!\n\n"))
}

# === Metagenomic Data Cleaning ===
metagenomic_data <- assay_data  # Renaming for clarity

cat("Checking metagenomic_data:\n")
print(head(metagenomic_data))
print(tail(metagenomic_data))
glimpse(metagenomic_data)
print(summary(metagenomic_data))
# skim(metagenomic_data) # Uncomment if your R session can handle it

# Replace NAs with 0 in numeric columns
metagenomic_data[] <- lapply(metagenomic_data, function(x) {
  if (is.numeric(x)) {
    x[is.na(x)] <- 0
  }
  return(x)
})

# Identify and remove all-zero columns
zero_columns <- colSums(metagenomic_data == 0, na.rm = TRUE)
zero_columns_clean <- zero_columns == nrow(metagenomic_data)
zero_columns_clean[is.na(zero_columns_clean)] <- FALSE
zero_column_names <- names(zero_columns_clean)[zero_columns_clean]
print(zero_column_names)
metagenomic_data_cleaned <- metagenomic_data[, !zero_columns_clean]

# Remove columns with >50% missing values (post-zero-removal step)
col_na_counts_cleaned <- colSums(is.na(metagenomic_data_cleaned))
na_threshold <- 0.5
valid_columns <- col_na_counts_cleaned < (na_threshold * nrow(metagenomic_data_cleaned))
metagenomic_data_cleaned <- metagenomic_data_cleaned[, valid_columns]

# === Save cleaned data ===
saveRDS(sample_data, "../../Data/Raw_data/Human_Microbiome_CleanUp/sample_data_cleaned.rds")
saveRDS(participant_data, "../../Data/Raw_data/Human_Microbiome_CleanUp/participant_data_cleaned.rds")
saveRDS(ontology_data, "../../Data/Raw_data/Human_Microbiome_CleanUp/ontology_data_cleaned.rds")
saveRDS(metagenomic_data_cleaned, "../../Data/Raw_data/Human_Microbiome_CleanUp/metagenomic_data_cleaned.rds")

cat("Data cleaning complete!\n")
cat("Data loaded and cleaned successfully, Pretty Girl! 💖\n")
