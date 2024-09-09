# extract the VCF for gene sets
cd /ohta2/meng.yuan/ceratodon/VCF_genes
for i in  "g_qt1" "g_qt2" "g_qt3" "g_qt4" "s_qt1" "s_qt2" "s_qt3" "s_qt4" "u_qt1" "u_qt2" "u_qt3" "u_qt4" "unbiased" "geness_a" "genesg_a"
do
bcftools view -R ./bed/${i}.bed ../pixy/ceratodon_gDNA.auto16.filt.nomiss.syn.vcf.gz \
-O v -o ./vcf/${i}.filt.nomiss.syn.vcf --threads 30 
bcftools view -R ./bed/${i}.bed ../pixy/ceratodon_gDNA.auto16.filt.nomiss.nonsyn.vcf.gz \
-O v -o ./vcf/${i}.filt.nomiss.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.filt.nomiss.syn.vcf  \
> ${i}.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.filt.nomiss.nonsyn.vcf \
> ${i}.filt.nonsyn.vcf.txt
done


# get SFS
for sample in "g_qt1" "g_qt2" "g_qt3" "g_qt4" "s_qt1" "s_qt2" "s_qt3" "s_qt4" "u_qt1" "u_qt2" "u_qt3" "u_qt4" "unbiased" "geness_a" "genesg_a"
do
/usr/local/bin/Rscript --vanilla sfs_bootstrap_auto.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_Oct/
done


# bootstrap data
for sample in "g_qt1" "g_qt2" "g_qt3" "g_qt4" "s_qt1" "s_qt2" "s_qt3" "s_qt4" "u_qt1" "u_qt2" "u_qt3" "u_qt4" "unbiased" "geness_a" "genesg_a"
do
for i in {1..200}; do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt bootstrap_Oct/${sample}.nonsyn.sfs_${i}.txt bootstrap_Oct/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}_bs.prop_muts.txt
done


