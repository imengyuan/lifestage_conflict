library(dplyr)
# setwd("~/Dropbox/ceratodon/c2023/vcf.txt")
setwd("/ohta2/meng.yuan/ceratodon/VCF_genes")

# read vcf
args = commandArgs(trailingOnly=TRUE)
vcf_syn <- read.table(paste0(args[1] ,".filt.syn.vcf.txt"),fill=TRUE)
vcf_nonsyn <- read.table(paste0(args[1] ,".filt.nonsyn.vcf.txt"),fill=TRUE)

for (x in seq(1, 200)) {
    # vcf_syn
    vcf_syn_bs = vcf_syn[sample(nrow(vcf_syn), nrow(vcf_syn), replace=TRUE), ]
    vcf_syn_bs$alt <- rowSums(vcf_syn_bs[,3:18]==1,na.rm=T)  
    vcf_syn_bs$minor <- ifelse(vcf_syn_bs$alt <= 8, vcf_syn_bs$alt, 16 - vcf_syn_bs$alt) 
    sfs_syn <- xtabs(~minor, data=vcf_syn_bs)
    file_out = paste0(args[1], ".syn.sfs_", x ,".txt")
    n <- 17 - length(sfs_syn)
    sfs_syn <- c(as.numeric(sfs_syn), numeric(n))
    write.table(t(sfs_syn), file=file_out, sep = " ", col.names =F, quote = F, row.names =F)
    # vcf_nonsyn
    vcf_nonsyn_bs = vcf_nonsyn[sample(nrow(vcf_nonsyn), nrow(vcf_nonsyn), replace=TRUE), ]
    vcf_nonsyn_bs$alt <- rowSums(vcf_nonsyn_bs[,3:18]==1,na.rm=T)
    vcf_nonsyn_bs$minor <- ifelse(vcf_nonsyn_bs$alt <= 8, vcf_nonsyn_bs$alt, 16 - vcf_nonsyn_bs$alt)
    sfs_nonsyn <- xtabs(~minor, data=vcf_nonsyn_bs)
    file_out <- paste0(args[1], ".nonsyn.sfs_", x ,".txt")
    n <- 17 - length(sfs_nonsyn)
    sfs_nonsyn <- c(as.numeric(sfs_nonsyn), numeric(n))
    write.table(t(sfs_nonsyn), file=file_out, sep = " ", col.names =F, quote = F, row.names =F)
}

