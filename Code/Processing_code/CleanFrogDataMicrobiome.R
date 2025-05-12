# Load libraries
library(pheatmap)
library(dplyr)

# Read taxonomy data
taxonomy <- read.csv("../../Data/Raw_data/frog_OTU_table.csv", 
                     stringsAsFactors = FALSE)

# Read the data without setting row names initially
abundance <- read.csv("../../Data/Raw_data/sampledata_with_otu_counts.csv", stringsAsFactors = FALSE, check.names = FALSE)


# Check the first few rows to see how the data is structured
head(abundance)

# Check if there are duplicates in the OTU_ID column (which is likely the first column)
duplicated_otu_ids <- sum(duplicated(abundance$OTU_ID))

if (duplicated_otu_ids > 0) {
  cat("Warning: There are duplicate OTU IDs. Number of duplicates:", duplicated_otu_ids, "\n")
  # Remove rows with duplicate OTU_ID (optional)
  abundance <- abundance[!duplicated(abundance$OTU_ID), ]
} else {
  cat("No duplicates found.\n")
}

# Data Check
head(abundance)
head(taxonomy)
tail(abundance)
tail(taxonomy)
glimpse(abundance)
glimpse(taxonomy)
summary(abundance)
summary(taxonomy)

# Remove rows with NA in OTU_ID before merging (optional)
abundance <- abundance[!is.na(abundance$OTU_ID), ]

# Assign row names based on the OTU_ID column (if you need them)
rownames(abundance) <- abundance$OTU_ID

# Clean and prepare taxonomy
taxonomy$Genus[is.na(taxonomy$Genus)] <- "Unclassified"
taxonomy$Phylum[is.na(taxonomy$Phylum)] <- "Unclassified"

# Add OTU_ID back to abundance for merging
abundance$OTU_ID <- rownames(abundance)

# Merge abundance and taxonomy
merged <- merge(abundance, taxonomy[, c("OTU_ID", "Genus", "Phylum")], by = "OTU_ID", all.x = TRUE)

# Check for any NA values in the merged data
if (any(is.na(merged))) {
  cat("Warning: There are NA values in the merged data.\n")
}

# Set unique rownames
rownames(merged) <- paste(merged$OTU_ID, merged$Genus, sep = "_")

# Create matrix for heatmap
abundance_matrix <- merged[, !(colnames(merged) %in% c("OTU_ID", "Genus", "Phylum"))]

# Create annotation for rows (OTUs) by Phylum
row_annotation <- data.frame(Phylum = merged$Phylum)
rownames(row_annotation) <- rownames(merged)

# Generate distinct colors for Phylum
phylum_colors <- setNames(rainbow(length(unique(row_annotation$Phylum))), unique(row_annotation$Phylum))
annotation_colors <- list(Phylum = phylum_colors)

# Plot heatmap
pheatmap(as.matrix(abundance_matrix),
         scale = "row",
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         annotation_row = row_annotation,
         annotation_colors = annotation_colors,
         color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
         fontsize_row = 10,  # Adjust if necessary
         show_rownames = FALSE)
