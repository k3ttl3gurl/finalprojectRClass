# Load necessary library
library(readr)

# Set the file paths (adjust these to your actual file paths)
input_tsv <- "C:/Users/brnna/classr/Final Project_Correa/Data/Raw_data/hmp_manifest_metadata_fecalda.tsv"   # Path to .tsv file
output_csv <- "C:/Users/brnna/classr/Final Project_Correa/Data/Raw_data/hmp_manifest_metadata_fecalda.csv"      # Path where to save the .csv file

# Read in the TSV file
data <- read_tsv(input_tsv)

# Write the data to a CSV file
write_csv(data, output_csv)

# Print confirmation
cat("File successfully converted from TSV to CSV! :)\n")
