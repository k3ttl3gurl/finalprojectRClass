# Load necessary libraries
library(dplyr)
library(tidyr)
library(vegan)
library(ggplot2)
library(stringr)

# 1. Check common samples between OTU table and metadata
otu_samples <- colnames(otu_matrix)  # Column names (samples) from OTU matrix
metadata_samples <- metadata$meta_sample_name  # Assuming 'meta_sample_name' is the column with sample names in metadata

# Clean up sample names to avoid mismatches due to spaces or case sensitivity
otu_samples <- str_squish(str_to_lower(otu_samples))
metadata_samples <- str_squish(str_to_lower(metadata_samples))

# Find common samples
common_samples <- intersect(otu_samples, metadata_samples)
print(common_samples)

# If common_samples is empty, stop the analysis
if (length(common_samples) == 0) {
  stop("No matching samples between OTU data and metadata.")
}

# 2. Subset metadata to common samples
metadata_filtered <- metadata %>% filter(meta_sample_name %in% common_samples)

# Ensure the row names of metadata match the sample names
rownames(metadata_filtered) <- metadata_filtered$meta_sample_name

# 3. Subset OTU table to common samples
otu_matrix <- otu_matrix[, common_samples]

# 4. Calculate Alpha Diversity (Shannon Index)
alpha_div <- diversity(otu_matrix, index = "shannon")

# Convert the results to a data frame for easier plotting
alpha_div_df <- data.frame(sample_name = names(alpha_div), Shannon = alpha_div)

# Merge alpha diversity results with metadata for plotting
alpha_div_df <- left_join(alpha_div_df, metadata_filtered, by = c("sample_name" = "meta_sample_name"))

# 5. Plot Alpha Diversity (Shannon Index) and Save Image
alpha_div_plot <- ggplot(alpha_div_df, aes(x = bd_status, y = Shannon, fill = sex)) +
  geom_boxplot() +
  labs(title = "Shannon Diversity by Bd Status", x = "Bd Status", y = "Shannon Index") +
  theme_minimal()

# Print the plot to the screen
print(alpha_div_plot)

# Save the plot to the specified directory
ggsave("C:/Users/brnna/classr/Final Project_Correa/Images/shannon_diversity_plot.png", plot = alpha_div_plot, width = 8, height = 6)

# 6. Calculate Bray-Curtis distance for PCoA
bray_curtis_dist <- vegdist(t(otu_matrix), method = "bray")

# Perform PCoA (Principal Coordinate Analysis)
pcoa_result <- cmdscale(bray_curtis_dist, k = 2)

# Convert the result into a data frame for easier plotting
pcoa_df <- as.data.frame(pcoa_result)
colnames(pcoa_df) <- c("PC1", "PC2")
pcoa_df$sample_name <- rownames(pcoa_df)

# Merge PCoA results with metadata for plotting
pcoa_df <- left_join(pcoa_df, metadata_filtered, by = c("sample_name" = "meta_sample_name"))

# 7. Plot PCoA - Bray Curtis and Save Image
pcoa_plot <- ggplot(pcoa_df, aes(x = PC1, y = PC2, color = sex, shape = bd_status)) +
  geom_point(size = 3) +
  labs(title = "PCoA - Bray Curtis", x = "PC1", y = "PC2") +
  theme_minimal()

# Print the plot to the screen
print(pcoa_plot)

# Save the plot to the specified directory
ggsave("C:/Users/brnna/classr/Final Project_Correa/Images/pcoa_bray_curtis_plot.png", plot = pcoa_plot, width = 8, height = 6)

cat("Successful Microbiome Analysis!\n")

