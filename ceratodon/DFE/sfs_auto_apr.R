library(dplyr)
# setwd("~/Dropbox/ceratodon/c2023/vcf.txt")
setwd("/ohta2/meng.yuan/ceratodon/VCF_genes")

args <- commandArgs(trailingOnly=TRUE)
file_prefix <- args[1]
vcf_syn_bs <- read.table(paste0(file_prefix, ".filt.syn.vcf.txt"), fill=TRUE)
vcf_nonsyn_bs <- read.table(paste0(file_prefix, ".filt.nonsyn.vcf.txt"), fill=TRUE)

# vcf_syn
vcf_syn_bs$alt <- rowSums(vcf_syn_bs[, 3:18] == 1, na.rm=TRUE)
vcf_syn_bs$minor <- ifelse(vcf_syn_bs$alt <= 8, vcf_syn_bs$alt, 16 - vcf_syn_bs$alt)
sfs_syn <- xtabs(~minor, data=vcf_syn_bs)
n <- 17 - length(sfs_syn)
sfs_syn <- c(as.numeric(sfs_syn), numeric(n))
write.table(t(sfs_syn), file=paste0(file_prefix, ".syn.sfs.txt"), sep=" ", col.names=FALSE, quote=FALSE, row.names=FALSE)

# vcf_nonsyn
vcf_nonsyn_bs$alt <- rowSums(vcf_nonsyn_bs[, 3:18] == 1, na.rm=TRUE)
vcf_nonsyn_bs$minor <- ifelse(vcf_nonsyn_bs$alt <= 8, vcf_nonsyn_bs$alt, 16 - vcf_nonsyn_bs$alt)
sfs_nonsyn <- xtabs(~minor, data=vcf_nonsyn_bs)
n <- 17 - length(sfs_nonsyn)
sfs_nonsyn <- c(as.numeric(sfs_nonsyn), numeric(n))
write.table(t(sfs_nonsyn), file=paste0(file_prefix, ".nonsyn.sfs.txt"), sep=" ", col.names=FALSE, quote=FALSE, row.names=FALSE)

