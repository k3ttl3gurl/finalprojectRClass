## Script for Phylogenetic Tree Creation ##

# Load necessary package
library(ape)

# Your Newick tree string
newick_tree <- "('AF549373.1':0.0,('AF308124.1':0.6384805537098486,('MN781638.1':0.1016528955796044,('KX697980.1':0.13860335660157844,'KJ833337.1':0.10964374475120703):0.03638383273165022):0.9465461173741643):0.0);"

# Read the Newick tree
tree <- read.tree(text = newick_tree)

# Plot the tree
plot(tree, main = "Phylogenetic Tree", cex = 0.8)

# Plot the tree with tip labels
plot(tree, show.tip.label = TRUE, cex = 0.8)

# Add a horizontal tree with colored tips
plot(tree, type = "phylogram", tip.color = "blue", cex = 0.9, main = "Styled Phylogenetic Tree")

# Add node numbers to the tree (using edge labels for internal nodes)
nodelabels(node = 1:Nnode(tree), cex = 0.7, adj = c(0.5, -0.5))
