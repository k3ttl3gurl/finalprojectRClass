# README.md

# Overview:
The National Institutes of Health (NIH) Human Microbiome Project (HMP) aims to map the microorganisms (microbiota) that live in and on the human body and to understand their role in human health. By using advanced sequencing technologies, the HMP has generated one of the largest and most well-documented microbiome datasets in the world. It provides a comprehensive reference for understanding microbial communities from various body sites, including the gastrointestinal (gut) tract.

The HMP has been invaluable for studying the microbiome's role in human health, disease, and physiology. It focuses on understanding the interplay between human hosts and microbes and how this relationship impacts conditions like obesity, diabetes, and various gastrointestinal disorders.

# Why I Chose 16S Data:
For my project, I decided to focus on the 16S rRNA gene sequencing data from the HMP. This gene is a highly conserved region of DNA that is found in all bacteria and archaea, making it an excellent marker for microbial identification and classification. The 16S data provides a rich resource for studying microbial diversity, abundance, and the relative composition of microbial communities in the human gut.

16S rRNA sequencing is a widely-used method for microbial community profiling, particularly in studies of gut microbiomes. Its relatively low cost, high throughput, and ability to identify a broad range of microorganisms make it the ideal choice for my research, particularly as I aim to understand microbiome dynamics in relation to gastrointestinal health.

# Why the HMP:
The Human Microbiome Project (HMP) is regarded as the most complete and well-documented microbiome reference available. It includes data from a variety of human body sites (including the gut) and is supported by extensive metadata, making it an excellent choice for microbiome research. The HMP’s extensive coverage and the credibility of its datasets have made it a standard resource in the field.

# Citation:
You can access the data through the NIH Human Microbiome Project Data Portal at the following link: Human Microbiome Project Data Portal

For reference, please cite the project as follows: The Human Microbiome Project Consortium. "A framework for human microbiome research." Nature 486, 215–221 (2012). DOI: 10.1038/nature11209

# Dr. Presting notes

# Using readr
library(readr)
data <- read_tsv("path_to_file.tsv")  # Load the TSV
write_csv(data, "path_to_output.csv")  # Save it as CSV

# Or using base R
data <- read.delim("path_to_file.tsv")  # Load the TSV
write.csv(data, "path_to_output.csv", row.names = FALSE)  # Save it as CSV


# Data Dictionary 




