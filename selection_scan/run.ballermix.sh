########################## in ceratodon #################
output <- read.table("ceratodon_gDNA.auto.filt.vcf.allele.cnt", header=T)
output$cnt_derived <- ifelse(output$outgroup == "0", output$cnt_alt, output$cnt_ref)
output$genPos <- 0
# output <- output[order(output$chrom, output$physPos),]
output<- output %>% select(chrom, physPos, genPos, cnt_derived, n)
output <- output %>% filter(cnt_derived != 0)
write.table(output, file = "ceratodon_input_DAF.txt", row.names = FALSE, quote = FALSE, sep = "\t"


python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF.txt --getSpect --spect ceratodon_spect_DAF.txt

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF.txt  -o ceratodon_scan_DAF.txt --spect ceratodon_spect_DAF.txt





####################### rumex ############################
# in R
pileup<- read.table("hast_buceph.mpileup.txt")
colnames(pileup) <- c("chrom","physPos", "ref_pileup", "outgroup")
pileup <- pileup %>% filter(nchar(pileup[,4]) == 1) 
pileup <- pileup %>% filter(pileup[,4] != "*") 
write.table(pileup, file = "hast_buceph.mpileup.clean.txt", sep = "\t", row.names = F, quote = F)


eqtl20females.filt0329.vcf.allele.cnt # has header, 451423559
# use inner join to merge with allele count
allele_cnt <- read.table("eqtl20females.filt0329.vcf.allele.cnt",header=T)
output <- inner_join(allele_cnt, pileup, by=c("chrom","physPos")) # 32729
write.table(output, file = "mpileup_allele_cnt.txt", sep = "\t", row.names = F, quote = F)


# get DAF column
output$cnt_derived <- ifelse(output$outgroup == "," | output$outgroup == ".", output$cnt_alt, output$cnt_ref)
output <- output %>% filter(cnt_derived != 0) # 26913
write.table(output, file = "mpileup_allele_cnt_DAF.txt", row.names = FALSE, quote = FALSE, sep = "\t")


# format to input for ballermix, adding genetic position
gmap<- read.table("recombination/sexavg_monotonic_map.gmap")
colnames(gmap)<- c("chrom","physPos","m","f","genPos")

output2<-inner_join(output, gmap, by=c("chrom","physPos"))
write.table(output2, file = "mpileup_allele_cnt_DAF_genPos.txt", row.names = FALSE, quote = FALSE, sep = "\t")
output3<- output2 %>% select(chrom, physPos, genPos, cnt_derived, n)
output3<- output2[,c(1,2,14,11,8)]
output3 <- output3[order(output3$chrom, output3$physPos),]
write.table(output3, file = "rumex_input_DAF_May9.txt", row.names = FALSE, quote = FALSE, sep = "\t")


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=5:00:00
module load python
python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus-main/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt -o rumex_scan_DAF_May9.txt --spect rumex_spect_DAF_May9.txt


# ohta
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt --getSpect --spect rumex_spect_DAF_May9.txt

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt  -o rumex_scan_DAF_May9.txt --spect rumex_spect_DAF_May9.txt




