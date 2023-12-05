########################## in ceratodon #################
output <- read.table("ceratodon_gDNA.auto.filt.vcf.allele.cnt", header=T)
output$cnt_derived <- ifelse(output$outgroup == "0", output$cnt_alt, output$cnt_ref)
output$genPos <- 0
# output <- output[order(output$chrom, output$physPos),]
output<- output %>% select(chrom, physPos, genPos, cnt_derived, n)
output <- output %>% filter(cnt_derived != 0)
write.table(output, file = "ceratodon_input_DAF.txt", row.names = FALSE, quote = FALSE, sep = "\t"

# nov
library(dplyr)
output <- read.table("ceratodon_gDNA.auto.filt.vcf.allele.cnt", header=T)
output$cnt_derived <- ifelse(output$outgroup == "0", output$cnt_alt, output$cnt_ref)
output$genPos <- 0
output<- output %>% select(chrom, physPos, genPos, cnt_derived, n)
colnames(output)[4] <- "x"
output <- output %>% filter(x != 0)
write.table(output, file = "ceratodon_input_DAF_chrom.txt", row.names = FALSE, quote = FALSE, sep = "\t")

grep 'Chr01' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr01.txt
grep 'chr02' ceratodon_input_DAF_chrom.txt> ceratodon_input_DAF_chr02.txt

838285 ceratodon_input_DAF_Chr01.txt

cut -f 2-5

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF.txt --getSpect --spect ceratodon_spect_DAF.txt

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF.txt  -o ceratodon_scan_DAF.txt --spect ceratodon_spect_DAF.txt


#nov get 14 running and renice them
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01.txt  -o ceratodon_scan_DAF_Chr01.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_chr02.txt  -o ceratodon_scan_DAF_chr02.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001



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






# niagara ceratodon
scp meng.yuan@ohta.eeb.utoronto.ca:/ohta2/meng.yuan/ceratodon/ballermix/ceratodon_spect_DAF.txt ./

#!/bin/bash
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=80
#SBATCH --time=22:00:00
module load python
python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus-main/BalLeRMix+_v1.py -i ceratodon_input_DAF.txt  -o ceratodon_scan_DAF.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001



# ohta ceratodon
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF.txt  -o ceratodon_scan_DAF_real.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001

# break into chroms

4945567 rumex_input_DAF_May9.txt
7743903 ceratodon_input_DAF.txt
184834943 ceratodon_input_MAF_full.txt

  7743903 ceratodon_input_DAF.txt
   160154 ceratodon_scan_DAF_real.txt


# ohta rumex
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt --getSpect --spect rumex_spect_DAF_May9.txt
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt  -o rumex_scan_DAF_May9.txt --spect rumex_spect_DAF_May9.txt

# ohta try parallel

parallel --dry-run python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt  -o rumex_scan_DAF_May18.txt --spect rumex_spect_DAF_May9.txt



python3 BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt  -o rumex_scan_DAF_May18.txt --spect rumex_spect_DAF_May9.txt


# rumex on each LG
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_Jul6_LG${i}.txt  -o rumex_scan_DAF_Jul6_LG${i}.txt --spect rumex_spect_DAF_May9.txt --findBal


parallel --memfree 2G --jobs 15 python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt -o rumex_scan_DAF_May22.txt --spect rumex_spect_DAF_May9.txt





