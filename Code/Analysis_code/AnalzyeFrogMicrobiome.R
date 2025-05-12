# Load libraries
library(dplyr)
library(tidyr)
library(vegan)
library(ggplot2)

# 1. Load the data
otu_matrix <- read.csv("../../Data/Raw_data/frog_OTU_table.csv", row.names = NULL, check.names = FALSE)
metadata <- read.csv("../../Data/Raw_data/SraRunTable_Seq.csv", stringsAsFactors = FALSE)

# 2. Check column names
stopifnot("sample_name" %in% colnames(otu_matrix))
stopifnot("sample_name" %in% colnames(metadata))

# 3. Aggregate OTU table by genus and sample_name
otu_agg <- otu_matrix %>%
  group_by(genus, sample_name) %>%
  summarise(total_count = sum(count), .groups = "drop")

# 4. Pivot OTU table: samples as rows, genera as columns
otu_wide <- otu_agg %>%
  pivot_wider(names_from = genus, values_from = total_count, values_fill = 0)

# 5. Merge with metadata
merged_data <- metadata %>%
  inner_join(otu_wide, by = "sample_name")

cat("Samples in metadata:", nrow(metadata), "\n")
cat("Samples after merge:", nrow(merged_data), "\n")

write.csv(merged_data, "merged_metadata_otu.csv", row.names = FALSE)

# -------------------------
# 2. Summary Tables
# -------------------------
cat("\nBd Status Breakdown:\n")
print(table(metadata$Bd_status))

cat("\nBd Status by Age Class:\n")
print(table(metadata$age_class, metadata$Bd_status))

cat("\nBd Status by Host Species:\n")
print(table(metadata$HOST, metadata$Bd_status))

# -------------------------
# 3. Alpha Diversity - Shannon Index
# -------------------------
# Extract genus columns only
otu_numeric <- otu_wide %>%
  select(-sample_name) %>%
  as.data.frame()
rownames(otu_numeric) <- otu_wide$sample_name

# Shannon diversity
alpha_div <- diversity(otu_numeric, index = "shannon")

alpha_div_df <- data.frame(
  sample_name = names(alpha_div),
  Shannon = alpha_div
)

alpha_div_df <- left_join(
  alpha_div_df,
  metadata,
  by = "sample_name"
)

alpha_div_plot <- ggplot(alpha_div_df, aes(x = Bd_status, y = Shannon, fill = sex)) +
  geom_boxplot() +
  labs(title = "Shannon Diversity by Bd Status", x = "Bd Status", y = "Shannon Index") +
  theme_minimal()

print(alpha_div_plot)

ggsave("C:/Users/brnna/classr/Final Project_Correa/Images/shannon_diversity_plot.png", 
       plot = alpha_div_plot, width = 8, height = 6)

# -------------------------
# 4. Beta Diversity - Bray-Curtis PCoA
# -------------------------
bray_curtis_dist <- vegdist(otu_numeric, method = "bray")
pcoa_result <- cmdscale(bray_curtis_dist, k = 2)
pcoa_df <- as.data.frame(pcoa_result)
colnames(pcoa_df) <- c("PC1", "PC2")
pcoa_df$sample_name <- rownames(pcoa_result)

pcoa_df <- left_join(
  pcoa_df,
  metadata,
  by = "sample_name"
)

pcoa_plot <- ggplot(pcoa_df, aes(x = PC1, y = PC2, color = sex, shape = Bd_status)) +
  geom_point(size = 3) +
  labs(title = "PCoA - Bray Curtis", x = "PC1", y = "PC2") +
  theme_minimal()

print(pcoa_plot)

ggsave("C:/Users/brnna/classr/Final Project_Correa/Images/pcoa_bray_curtis_plot.png", 
       plot = pcoa_plot, width = 8, height = 6)

# -------------------------
# 5. Map Sample Locations by Bd Status
# -------------------------
if (all(c("LATITUDE", "LONGITUDE") %in% colnames(metadata))) {
  location_plot <- ggplot(metadata, aes(x = LONGITUDE, y = LATITUDE, color = Bd_status)) +
    geom_point() +
    theme_minimal() +
    labs(title = "Geographic Distribution of Bd Status")
  
  print(location_plot)
  
  ggsave("C:/Users/brnna/classr/Final Project_Correa/Images/geographic_distribution_plot.png", 
         plot = location_plot, width = 8, height = 6)
} else {
  cat("LATITUDE and LONGITUDE columns not found in metadata.\n")
}

# -------------------------
# 6. Filter Positive Bd Samples from Guatemala
# -------------------------
positive_guatemala <- subset(metadata, Bd_status == "Positive" & grepl("Guatemala", geo_loc_name, ignore.case = TRUE))

cat("\nNumber of Bd-positive samples from Guatemala:", nrow(positive_guatemala), "\n")
print(positive_guatemala[, c("sample_name", "geo_loc_name", "Bd_status")])
