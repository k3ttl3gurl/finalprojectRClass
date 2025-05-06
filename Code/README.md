# Code Folder

## Code Location:

Scripts will be placed in `.R` or `.qmd` scripts in the following folders:

- Processing_code is for cleaning raw data to processed data (Project 1)
- Analysis_code or your analyses on cleaned data (Project 2)


## Code Design:

The processing_code script is one large script that does many things. It is contained all together to avoid confusion during the data cleaning process. For the questions handled in Project 2 script design will rely on multiple scripts that do only specific action. 

These will all use relative pathways but also determined pathways noted in the manuscript should there be issues in locating these items. 

## Documentation for processing_data Script:

* PURPOSE: Cleaning and processing raw data for analysis
* Input: Raw data file:
* Output: Processed data file:

Aided in removing missing values, standardizing columns, names, filtered outliers. Allowed for the preparation of the dataset for the analysis that addresses questions in regards to the manuscript. 

## Documentation for Analysis_code

* PURPOSE: Calculates and summarizes key statistics for the penguin dataset in relation to the questions posed in the manuscript. (See Manuscript.qmd C:\Users\brnna\classr\BriannaCorrea-Rclass-project1\Products\Manuscript)
* Input:
- Descripting Stats: .rds
- Statistical Modeling: .rds
- Visualization: .rds
* Output:
- - Descripting Stats: .png
- Statistical Modeling: Tables in manuscript
- Visualization: .png

## Documentation for Phylogenetic Tree
* Purpose: Summarize host species in phylogenetic tree, mostly for practice

## Order of Execution:

Run Script 1 (Data Processing and Cleaning) first to prepare the data.

Run Script 2 (Summary Statistics) to calculate descriptive stats and create visual summaries.

Run Script 3 (Model Analysis) to conduct statistical modeling and fit relevant models.

Run Script 4 (Exploratory Visualization) last to generate visualizations based on the clean and analyzed data.

