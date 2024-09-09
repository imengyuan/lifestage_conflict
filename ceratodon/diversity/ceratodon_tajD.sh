bcftools view -R siteType/R40_GG1U_combined.nonsyn.chrom_pos \
VCF_Feb/ceratodon_gDNA.auto_variant.vcf.gz -O z -o ceratodon_gDNA.auto_variant.filt_nonsyn.vcf.gz --threads 30

bcftools view -R siteType/R40_GG1U_combined.syn.chrom_pos \
VCF_Feb/ceratodon_gDNA.auto_variant.vcf.gz  -O z -o ceratodon_gDNA.auto_variant.filt_syn.vcf.gz  --threads 30

tabix -p vcf ceratodon_gDNA.auto_variant.filt_nonsyn.vcf.gz
tabix -p vcf ceratodon_gDNA.auto_variant.filt_syn.vcf.gz

# syn
python3 /ohta1/meng.yuan/apps/genomics_general/VCF_processing/parseVCFs.py -i ceratodon_gDNA.auto_variant.filt_syn.vcf.gz  --ploidy 1 --threads 30 | bgzip > ceratodon_gDNA.auto_variant.filt.syn.geno.gz


python3 /ohta1/meng.yuan/apps/genomics_general/popgenWindows.py --windType predefined --windCoords ../pixy/R40_GG1U_combined.auto.bed -g ceratodon_gDNA.auto_variant.filt.syn.geno.gz -o tajD_auto_variant_syn.csv.gz -f haplo -T 30 -p Pop --popsFile ../pixy/popfile_auto.txt --analysis popFreq --writeFailedWindows

# nonsyn
python3 /ohta1/meng.yuan/apps/genomics_general/VCF_processing/parseVCFs.py -i ceratodon_gDNA.auto_variant.filt_nonsyn.vcf.gz  --ploidy 1 --threads 30 | bgzip > ceratodon_gDNA.auto_variant.filt.nonsyn.geno.gz


python3 /ohta1/meng.yuan/apps/genomics_general/popgenWindows.py --windType predefined --windCoords ../pixy/R40_GG1U_combined.auto.bed -g ceratodon_gDNA.auto_variant.filt.nonsyn.geno.gz -o tajD_auto_variant_nonsyn.csv.gz -f haplo -T 30 -p Pop --popsFile ../pixy/popfile_auto.txt --analysis popFreq --writeFailedWindows
