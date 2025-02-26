# Testing for conflict between life stages

This repository contains the scripts for the following manuscript:

>Yuan M, Kollar LM, Sacchi BM, Carey SB, Choudhury BI, Jones T, Grimwood J, Barrett SCH, McDaniel SF, Wright SI, Stinchcombe JR. 2024. Testing for the genomic footprint of conflict between life stages in an angiosperm and a moss species. [bioRxiv. 2024:2024.10.04.613734](https://www.biorxiv.org/content/10.1101/2024.10.04.613734v1). 

The same analyses were repeated in the angiosperm *Rumex hastatulus* and the moss *Ceratodon purpureus*, you can find the scripts in the folders `rumex` and `ceratodon`, respectively.

---

Here's a brief description of the folders containing scripts for different analyses:

* `variant_calling`: Alignment, BAM processing and variant calling from raw WGS data.
* `expression`: Alignment and BAM processing from raw RNA-Seq data, differential gene expression analyses using DESeq2.
* `diversity`: Diversity statistics including nucleotide diversity $\pi$ and Tajima's D.
* `selection_scan`: Model-based genome-wide scan for balancing selection.
* `DFE`: Distribution of fitness effect analyses.