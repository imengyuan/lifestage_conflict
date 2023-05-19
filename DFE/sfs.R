library(dplyr)
setwd("/ohta2/meng.yuan/rumex/diversity2022/bootstrap")
# read vcf
args = commandArgs(trailingOnly=TRUE)
vcf_syn <- read.table(paste0(args[1] ,".syn.filt0329.vcf.txt"),fill=TRUE,row.names=NULL)
vcf_nonsyn <- read.table(paste0(args[1] ,".nonsyn.filt0329.vcf.txt"),fill=TRUE,row.names=NULL)

# vcf_syn    
#vcf_syn = vcf_syn[sample(nrow(vcf_syn), nrow(vcf_syn), replace=TRUE), ]
vcf_syn$alt <- rowSums(vcf_syn[,3:42]==1,na.rm=T)
vcf_syn$minor <- case_when(vcf_syn$alt <= 20 ~ vcf_syn$alt, vcf_syn$alt > 20 ~ 40 - vcf_syn$alt)
sfs_syn = data.frame(table(vcf_syn$minor))
file_out = paste0(args[1], ".syn.sfs.txt")
sfs_syn <- as.data.frame(c(sfs_syn[,2],replicate(20, 0)))
write.table(t(sfs_syn), file=file_out, sep = " ", col.names =F, quote = F, row.names =F)
    
# vcf_nonsyn
#vcf_nonsyn = vcf_nonsyn[sample(nrow(vcf_nonsyn), nrow(vcf_nonsyn), replace=TRUE), ]
vcf_nonsyn$alt <- rowSums(vcf_nonsyn[,3:42]==1,na.rm=T)
vcf_nonsyn$minor <- case_when(vcf_nonsyn$alt <= 20 ~ vcf_nonsyn$alt, vcf_nonsyn$alt > 20 ~ 40 - vcf_nonsyn$alt)
sfs_nonsyn <- data.frame(table(vcf_nonsyn$minor))
file_out <- paste0(args[1], ".nonsyn.sfs.txt")
sfs_nonsyn <- as.data.frame(c(sfs_nonsyn[,2],replicate(20, 0)))
write.table(t(sfs_nonsyn), file=file_out, sep = " ", col.names =F, quote = F, row.names =F)

