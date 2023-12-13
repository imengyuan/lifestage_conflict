

gff <- read.table(paste0(directory,"REF_LA_filtered_annotation.genes.gff"))
colnames(gff) <- c("gene","chrom", "start", "end")
scan1 <- read.table("rumex_scan_DAF_Jul6_LG1.txt", header = T)
scan2 <- read.table("rumex_scan_DAF_Jul6_LG2.txt", header = T)
scan3 <- read.table("rumex_scan_DAF_Jul6_LG3.txt", header = T)
scan4 <- read.table("rumex_scan_DAF_Jul6_LG4.txt", header = T)
scan5 <- read.table("rumex_scan_DAF_Jul6_LG5.txt", header = T)
scan1$chrom <- "LG1"
scan2$chrom <- "LG2"
scan3$chrom <- "LG3"
scan4$chrom <- "LG4"
scan5$chrom <- "LG5"

result <- scan1 %>% inner_join(gff, by = "chrom") %>%
    filter(physPos >= start & physPos <= end) 

write.table(result, file="balsel_sites.txt", row.names = FALSE, quote = FALSE)