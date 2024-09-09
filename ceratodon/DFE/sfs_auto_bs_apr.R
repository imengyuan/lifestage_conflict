library(dplyr)
setwd("~/Dropbox/ceratodon/c2023/vcf.txt")
# read vcf
args = commandArgs(trailingOnly=TRUE)
file_prefix <- args[1]
vcf_syn <- read.table(paste0(file_prefix,".filt.syn.vcf.txt"), fill=TRUE)
vcf_nonsyn <- read.table(paste0(file_prefix,".filt.nonsyn.vcf.txt"), fill=TRUE)

generate_sfs <- function(vcf, prefix) {
    for (x in seq(1, 200)) {
        vcf_bs <- vcf[sample(nrow(vcf), nrow(vcf), replace=TRUE), ]
        vcf_bs$alt <- rowSums(vcf_bs[, 3:18] == 1, na.rm=TRUE)  
        vcf_bs$minor <- case_when(vcf_bs$alt <= 8 ~ vcf_bs$alt, vcf_bs$alt > 8 ~ 16 - vcf_bs$alt)  
        sfs <- data.frame(table(vcf_bs$minor))
        file_out <- paste0(prefix, x, ".txt")
        n <- 17 - nrow(sfs)
        sfs <- as.data.frame(c(sfs[, 2], replicate(n, 0))) 
        write.table(t(sfs), file=file_out, sep=" ", col.names=FALSE, quote=FALSE, row.names=FALSE)
    }
}

generate_sfs(vcf_syn, paste0(file_prefix, ".syn.sfs_"))
generate_sfs(vcf_nonsyn, paste0(file_prefix, ".nonsyn.sfs_"))
