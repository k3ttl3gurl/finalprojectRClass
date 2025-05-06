# Load necessary libraries
library(tidyverse)
library(readr)
library(here)

# === DEFINE FILE PATHS ===

otu_file_path <- here("Data", "Raw_data", "salamander_OTU_table.csv")
metadata_file_path <- here("Data", "Raw_data", "SraRunTable_Seq.csv")

# === LOAD AND CLEAN DATA ===
otu_data <- read.csv("Final Project_Correa/Data/Raw_data/salamander_OTU_table.csv")

metadata <- read.csv("Final Project_Correa/Data/Raw_data/metadata_with_otu_counts.csv")

# === EXPLORE STRUCTURE & MISSING VALUES ===
glimpse(otu_data)
glimpse(metadata)

cat("\nMissing values in OTU data:\n")
print(colSums(is.na(otu_data))[colSums(is.na(otu_data)) > 0])

cat("\nMissing values in metadata:\n")
print(colSums(is.na(metadata))[colSums(is.na(metadata)) > 0])

# Find which columns are the actual sample names
otu_sample_cols <- otu_data %>%
  select(where(is.numeric)) %>%
  colnames()

# Now pivot only those numeric columns
otu_long <- otu_data %>%
  pivot_longer(
    cols = all_of(otu_sample_cols),
    names_to = "sample_name",
    values_to = "otu_count"
  )

# === SUMMARIZE OTU COUNTS PER SAMPLE ===
otu_summary <- otu_long %>%
  group_by(sample_name) %>%
  summarise(total_otu_count = sum(otu_count, na.rm = TRUE))

# === JOIN OTU SUMMARY TO METADATA ===
combined_data <- metadata %>%
  left_join(otu_summary, by = "sample_name")

# === CLEAN DUPLICATES ===
combined_data <- combined_data %>%
  distinct()

# === EXAMINE KEY VARIABLES ===
key_cols <- c(
  "run", "sample_name", "organism", "site", "geo_loc_name", 
  "geo_loc_name_country", "geo_loc_name_country_continent",
  "bd_status", "age_class", "sex", "ze", "log_ze", 
  "latitude", "longitude", "collection_date", "elevation", "habitat"
)

# Print unique entries
for (col in key_cols) {
  if (col %in% colnames(combined_data)) {
    cat("Unique entries in", col, ":", length(unique(combined_data[[col]])), "\n")
  }
}

# === FREQUENCY TABLES ===
cat("\nBd_status breakdown:\n")
print(table(combined_data$bd_status))

cat("\nSites per location:\n")
print(table(combined_data$geo_loc_name))

cat("\nHosts per species:\n")
print(table(combined_data$organism))

# === VISUALIZATION ===

# Samples by geographic location
combined_data %>%
  count(geo_loc_name) %>%
  ggplot(aes(x = reorder(geo_loc_name, n), y = n)) +
  geom_col(fill = "darkorchid") +
  coord_flip() +
  labs(title = "Samples by Geographic Location", x = "Geo Location", y = "Count") +
  theme_minimal()

# Sample count by site
combined_data %>%
  count(site, sort = TRUE) %>%
  ggplot(aes(x = reorder(site, n), y = n)) +
  geom_col(fill = "forestgreen") +
  coord_flip() +
  labs(title = "Sample Count per Site", x = "Site", y = "Count") +
  theme_minimal()

# Bd_status by site
combined_data %>%
  count(site, bd_status) %>%
  ggplot(aes(x = site, y = n, fill = bd_status)) +
  geom_col(position = "dodge") +
  labs(title = "Bd Status by Site", x = "Site", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Total OTU count distribution
combined_data %>%
  ggplot(aes(x = total_otu_count)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  labs(title = "Total OTU Counts per Sample", x = "OTU Count", y = "Frequency") +
  theme_minimal()

# === SAVE CLEANED DATA ===
write.csv(combined_data, 
          "C:/Users/brnna/classr/Final Project_Correa/Data/Raw_data/metadata_with_otu_counts.csv", 
          row.names = FALSE)

cat("\n✅ Cleaning and visualizations completed successfully!\n")
