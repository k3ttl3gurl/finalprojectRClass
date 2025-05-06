# Load necessary libraries
library(ggplot2)  
library(dplyr)
library(tidyr)
library(readr)

# Load the original and cleaned data
metagenomic_data <- read_tsv("HMPWgs_Metagenomic_sequencing_assay.txt")  # Assuming raw data is in .tsv
metagenomic_data_cleaned <- readRDS("metagenomic_data_cleaned.rds")  # Loading the cleaned .rds data

# 1. Compare Missing Values Before and After Cleaning

# Get the number of missing values per column before and after cleaning
missing_values_before <- colSums(is.na(metagenomic_data))
missing_values_after <- colSums(is.na(metagenomic_data_cleaned))

# Combine into a data frame for easier plotting
missing_data_comparison <- data.frame(
  column = rep(names(missing_values_before), 2),
  missing_count = c(missing_values_before, missing_values_after),
  status = rep(c("Before", "After"), each = length(missing_values_before))
)

# Plot the missing values comparison
ggplot(missing_data_comparison, aes(x = column, y = missing_count, fill = status)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Comparison of Missing Values (Before vs After Cleaning)",
       x = "Columns", y = "Missing Values Count") +
  theme_minimal()

# 2. Compare Zero-Only Columns Before and After Cleaning

# Count columns that are entirely zeros before and after cleaning
zero_columns_before <- colSums(metagenomic_data == 0, na.rm = TRUE) == nrow(metagenomic_data)
zero_columns_after <- colSums(metagenomic_data_cleaned == 0, na.rm = TRUE) == nrow(metagenomic_data_cleaned)

# Create a comparison of columns that were zero only
zero_comparison <- data.frame(
  column = rep(names(zero_columns_before), 2),
  zero_count = c(zero_columns_before, zero_columns_after),
  status = rep(c("Before", "After"), each = length(zero_columns_before))
)

# Plot the zero-only columns comparison
ggplot(zero_comparison, aes(x = column, fill = status)) +
  geom_bar(stat = "count", position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Comparison of Zero-Only Columns (Before vs After Cleaning)",
       x = "Columns", y = "Zero-Only Count") +
  theme_minimal()

# 3. Visualizing the Distribution of Key Numeric Columns (Before vs After Cleaning)

# Select numeric columns
numeric_columns <- metagenomic_data %>% select(where(is.numeric))
numeric_columns_cleaned <- metagenomic_data_cleaned %>% select(where(is.numeric))

# Check if we have numeric columns before proceeding
if (ncol(numeric_columns) > 0) {
  # Choose the first numeric column to visualize as an example
  column_name <- names(numeric_columns)[1]
  
  # Plot histograms for the before and after cleaned versions of the first numeric column
  ggplot() +
    geom_histogram(data = metagenomic_data, aes_string(x = column_name), fill = "skyblue", color = "black", alpha = 0.6, bins = 30) +
    geom_histogram(data = metagenomic_data_cleaned, aes_string(x = column_name), fill = "orange", color = "black", alpha = 0.6, bins = 30) +
    labs(title = paste("Distribution of", column_name, "(Before vs After Cleaning)"),
         x = column_name, y = "Count") +
    scale_fill_manual(values = c("skyblue", "orange"), labels = c("Before", "After")) +
    theme_minimal()
} else {
  cat("No numeric columns found to visualize!\n")
}

cat("Data loaded successfully, Pretty Girl!\n")
