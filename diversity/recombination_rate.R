gmap <- read.table("/Users/yuanmeng/Downloads/sexavg_monotonic_map.map")
colnames(gmap) <- c("chrom", "end", "cM")

statsr_gmap <- inner_join(gmap, statsr, by = c("chrom","start"))
statsr_gmap2 <- inner_join(gmap, statsr, by = c("chrom","end"))


window_size <- 500
num_windows <- floor(nrow(statsr) / window_size) # 23

results <- list()
for (i in 1:24) {
    start <- (i - 1) * window_size + 1
    end <- i * window_size
    window_df <- statsr[start:end, ]
    
    result <- window_df %>% inner_join(gmap, by = "chrom") %>%
        filter(pos >= start & pos <= end) 
    
    results[[i]] <- result
}

result <- do.call(rbind, results)
