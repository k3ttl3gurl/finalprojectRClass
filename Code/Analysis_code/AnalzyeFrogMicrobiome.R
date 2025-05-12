# Load libraries
library(dplyr)
library(tidyr)
library(vegan)
library(ggplot2)

# 1. Load the data
otu_matrix <- read.csv("../../Data/Raw_data/frog_OTU_table.csv", check.names = FALSE)
metadata <- read.csv("../../Data/Raw_data/SraRunTable_Seq.csv")

# 2. Check for 'sample_name' in both
stopifnot("sample_name" %in% colnames(otu_matrix))
stopifnot("sample_name" %in% colnames(metadata))

# 3. Pivot OTU data to wide format: samples as rows, OTUs as columns
otu_wide <- otu_matrix %>%
  select(sample_name, OTU_ID, count) %>%
  pivot_wider(names_from = OTU_ID, values_from = count, values_fill = 0)

# 4. Merge with metadata
merged_data <- metadata %>%
  inner_join(otu_wide, by = "sample_name")

# 5. Save merged data
write.csv(merged_data, "../../Data/Processed_data/merged_metadata_otu.csv", row.names = FALSE)

# 6. Summary Tables
cat("\nBd Status Breakdown:\n")
print(table(metadata$Bd_status))

cat("\nBd Status by Age Class:\n")
print(table(metadata$age_class, metadata$Bd_status))

cat("\nBd Status by Host Species:\n")
print(table(metadata$HOST, metadata$Bd_status))

# 7. Alpha Diversity - Shannon Index
otu_only <- otu_wide %>%
  select(-sample_name)

alpha_div <- diversity(otu_only, index = "shannon")

alpha_div_df <- data.frame(
  sample_name = otu_wide$sample_name,
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

ggsave("../../Images/shannon_diversity_plot.png", 
       plot = alpha_div_plot, width = 8, height = 6)

# 8. Beta Diversity - Bray-Curtis PCoA
bray_curtis_dist <- vegdist(otu_only, method = "bray")
pcoa_result <- cmdscale(bray_curtis_dist, k = 2)
pcoa_df <- as.data.frame(pcoa_result)
colnames(pcoa_df) <- c("PC1", "PC2")
pcoa_df$sample_name <- otu_wide$sample_name

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

ggsave("../../Images/pcoa_bray_curtis_plot.png", 
       plot = pcoa_plot, width = 8, height = 6)

# 9. Sample Map
if (all(c("LATITUDE", "LONGITUDE") %in% colnames(metadata))) {
  location_plot <- ggplot(metadata, aes(x = LONGITUDE, y = LATITUDE, color = Bd_status)) +
    geom_point() +
    theme_minimal() +
    labs(title = "Geographic Distribution of Bd Status")
  
  print(location_plot)
  
  ggsave("../../Images/geographic_distribution_plot.png", 
         plot = location_plot, width = 8, height = 6)
} else {
  cat("LATITUDE and LONGITUDE columns not found in metadata.\n")
}

# 10. Filter for Positive Bd Samples from Guatemala
positive_guatemala <- subset(metadata, Bd_status == "Positive" & grepl("Guatemala", geo_loc_name, ignore.case = TRUE))

cat("\nNumber of Bd-positive samples from Guatemala:", nrow(positive_guatemala), "\n")
print(positive_guatemala[, c("sample_name", "geo_loc_name", "Bd_status")])

cat("\n Successfully Completed \n")
