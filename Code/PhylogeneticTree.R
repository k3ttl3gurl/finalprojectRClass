## Script for Phylogenetic Tree Creation with Species Names ##

# Load necessary package
library(ape)

# Your Newick tree string
newick_tree <- "('AF549373.1':0.0,('AF308124.1':0.6384805537098486,('MN781638.1':0.1016528955796044,('KX697980.1':0.13860335660157844,'KJ833337.1':0.10964374475120703):0.03638383273165022):0.9465461173741643):0.0);"

# Read the Newick tree
tree <- read.tree(text = newick_tree)

# Check original tip labels (this is important for debugging)
print(tree$tip.label)

# Clean up tip labels by removing extra quotes
tree$tip.label <- gsub("^'|'$", "", tree$tip.label)

# Define mapping from accession numbers to species names
tip_labels <- c(
  "AF549373.1" = "Scinax nebulosa",
  "AF308124.1" = "Dendropsophus elegans",
  "MN781638.1" = "Boana atlantica",
  "KX697980.1" = "Boana faber",
  "KJ833337.1" = "Dendropsophus aff. minutus"
)

# Check if the tip labels match and replace only those that exist in the tree
tree$tip.label <- ifelse(tree$tip.label %in% names(tip_labels), tip_labels[tree$tip.label], tree$tip.label)

# Check the updated tip labels (this is also important to confirm the update worked)
print(tree$tip.label)

# Plot the tree with the new labels
plot(tree, type = "phylogram", tip.color = "blue", cex = 0.9, main = "Phylogenetic Tree of Host Frog Species")

# Add node numbers
nodelabels(node = 1:Nnode(tree), cex = 0.7, adj = c(0.5, -0.5))

# Save the plot as PNG in specified folder

png(filename = "../Images/phylogenetic_tree.png", width = 800, height = 600)
plot(tree, type = "phylogram", tip.color = "blue", cex = 0.9, main = "Phylogenetic Tree of Host Frog Species")
nodelabels(node = 1:Nnode(tree), cex = 0.7, adj = c(0.5, -0.5))
dev.off()
