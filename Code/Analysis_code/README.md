Amphibian Microbiome Analysis: Frog-Only Replication of an Amphibian Study
Overview
This is a replicated microbiome analysis using only frogs, inspired by a broader amphibian study that compared salamander and frog skin microbiota. The original dataset structure was a bit messy, but it revealed some interesting patterns. I processed the data, rarefied the OTU table, and performed indicator species analysis by habitat type.


A heatmap showing relative abundance of bacterial OTUs across frog individuals grouped by habitat. Rows represent unique OTUs; columns are individual frogs. Colors represent percent abundance after rarefaction.

Indicator Species Analysis by Habitat
Frogs sampled from pine-oak forests exhibited a unique set of indicator bacterial taxa that were largely absent from those found in fir and cloud forests. Interestingly, fir and cloud forest frogs shared more similarities in their microbiomes. This suggests a strong influence of habitat type on microbial composition.

Heatmap rows: bacterial OTUs at species-level classification

Heatmap columns: individual frogs

Color scale: OTU abundance (percent of rarefied sequencing reads)

Vertical labels: Indicator OTUs associated with each habitat type

Image 2: [INSERT BARPLOT OR TREE]
A bar plot of top OTUs per habitat or a simplified version of the phylogenetic tree used.

Discussion
Results show that habitat has a stronger influence than host phylogeny at shallow taxonomic levels (e.g., within genera/species). While phylogenetic relatedness might explain differences at broader taxonomic scales, environmental factors seem to be the primary driver of microbial diversity in this frog-focused subset.

Frogs from the same habitat tended to share more OTUs than those from different habitats.

The presence of unique indicator taxa suggests possible environmental filtering by microhabitat conditions like moisture, elevation, and substrate.

This aligns with findings from previous amphibian microbiome studies, which showed that site and habitat can be stronger predictors of microbial community structure than host taxonomy.

Image 3: [INSERT GENERIC MICROBIOME CIRCLE DIAGRAM OR OTU NETWORK]
Use any diagram showing microbial diversity or relationships — even if it’s generic.

Limitations

Environmental microbiome samples were not included, so we can’t fully assess substrate influence.

All frogs sampled were from montane forest regions, so broader environmental conclusions are limited.

Conclusion
Despite the limited scope, this replication using frogs supports the original study’s findings: habitat plays a critical role in shaping amphibian skin microbiomes. Even in the absence of phylogenetic depth, clear differences in microbial community structure emerge across habitats.

Changes in habitat — through deforestation or climate shifts — may result in altered microbiome composition, potentially increasing vulnerability to pathogens like Batrachochytrium dendrobatidis (Bd).

Code and Data
Processed using R and Geneious

