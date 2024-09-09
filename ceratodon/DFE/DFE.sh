# extract the VCF for gene sets
for i in "g_specific" "s_specific"
do
bcftools view -R ./bed/${i}_auto_p01.bed ../pixy/ceratodon_gDNA.auto.filt.syn.vcf.gz \
-O v -o ./vcf/${i}.auto_p01.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}_auto_p01.bed ../pixy/ceratodon_gDNA.auto.filt.nonsyn.vcf.gz \
-O v -o ./vcf/${i}.auto_p01.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.auto_p01.filt.syn.vcf  \
> ${i}.auto_p01.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.auto_p01.filt.nonsyn.vcf \
> ${i}.auto_p01.filt.nonsyn.vcf.txt
done


# real data
sample=g_specific.auto_p01
sample=s_specific.auto_p01

/usr/local/bin/Rscript --vanilla sfs_bootstrap_auto.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_auto/

/usr/local/bin/Rscript --vanilla sfs_auto.R ${sample}

# 
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt s_specific.auto_p01.nonsyn.sfs.txt s_specific.auto_p01.syn.sfs.txt \
>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out

cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt g_specific.auto_p01.nonsyn.sfs.txt s_specific.auto_p01.syn.sfs.txt \
>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out



# bootstrapping

for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt bootstrap_auto/${sample}.nonsyn.sfs_${i}.txt bootstrap_auto/${sample}.syn.sfs_${i}.txt \
>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts.txt




