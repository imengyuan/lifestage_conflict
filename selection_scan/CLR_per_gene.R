
library(dplyr)
setwd("/ohta2/meng.yuan/rumex/ballermix/output")
gff <- read.table("/ohta2/meng.yuan/rumex/eqtl/RNA_readcnt/REF_LA_filtered_annotation.expressed_genes.gff", header =T)

gff1 <- gff %>% filter(chrom == "LG1")
scan1 <- read.table("/ohta2/meng.yuan/rumex/ballermix/output/rumex_scan_DAF_Jul6_LG1.txt", header = T)
scan1$chrom <- "LG1"

# need a loop
result1_1 <- scan1_1 %>% inner_join(gff1, by = "chrom") %>%
    filter(physPos >= start & physPos <= end) 

result1_CLR <- result1 %>%
    group_by(gene) %>%
    summarise(mean_CLR = mean(CLR), max_CLR = max(CLR), no_sites = length(CLR))

write.table(result1_CLR, file = "result1_CLR.txt", row.names = FALSE, quote = FALSE,sep = "\t")


# local
gff <- read.table("/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/rumex_haploid_sel/deseq2/REF_LA_filtered_annotation.expressed_genes.gff", header =T)
scan1 <- read.table("/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/rumex_haploid_sel/balsel/rumex_scan_DAF_Jul6_LG1.txt", header = T)


window_size <- 10000
num_windows <- floor(nrow(scan1) / window_size)
results <- list()
for (i in 1:3) {
    start <- (i - 1) * window_size + 1
    end <- i * window_size
    window_df <- scan1[start:end, ]

    result <- window_df %>% inner_join(gff1, by = "chrom") %>%
        filter(physPos >= start & physPos <= end) 
    
    results[[i]] <- result
}
final_result <- unlist(results)



result1 <- test %>% inner_join(gff1, by = "chrom") %>%
    filter(physPos >= start & physPos <= end) 

#result1$gene <- as.factor(result1$gene)
result1 <- scan1 %>% inner_join(gff, by = "chrom") %>%
    filter(physPos >= start & physPos <= end) 

nrow(result1)
write.table(result1, file = )
table(result1$gene)

result1_CLR <- result1 %>%
    group_by(gene) %>%
    summarise(mean_CLR = mean(CLR), max_CLR = max(CLR), no_sites = length(CLR))






scan2 <- read.table("rumex_scan_DAF_Jul6_LG2.txt", header = T)
scan3 <- read.table("rumex_scan_DAF_Jul6_LG3.txt", header = T)
scan4 <- read.table("rumex_scan_DAF_Jul6_LG4.txt", header = T)
scan5 <- read.table("rumex_scan_DAF_Jul6_LG5.txt", header = T)
scan2$chrom <- "LG2"
scan3$chrom <- "LG3"
scan4$chrom <- "LG4"
scan5$chrom <- "LG5"


write.table(result, file="balsel_sites.txt", row.names = FALSE, quote = FALSE)