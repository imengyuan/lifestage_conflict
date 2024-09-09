
# apr 17
for sample in "g_specific.auto_p01" "s_specific.auto_p01"
do
/usr/local/bin/Rscript --vanilla sfs_bs_auto_alpha.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_alpha_Apr17/
mv ${sample}*.divergence_*.txt bootstrap_alpha_Apr17/
done



# try a bigger set
for i in "g" "s"
do
for j in "qt1" "qt2" "qt3" "qt4"
do
/usr/local/bin/Rscript --vanilla sfs_auto_apr.R ${i}_${j}.auto
done
done

# test
for sample  in "g_qt1.auto" "s_qt1.auto"
do 
/usr/local/bin/Rscript --vanilla sfs_bs_auto_alpha.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_alpha_Apr_test/
mv ${sample}*.divergence_*.txt bootstrap_alpha_Apr_test/
done

for sample in "g_qt1.auto" "s_qt1.auto"
do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt ${sample}.nonsyn.sfs.txt ${sample}.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cp ${sample}_divergence.txt ../dfe_a/divergence.txt

cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt # double check this
cut  -d' ' -f 6,8 est_alpha_omega.out>${sample}_real_Apr18.alpha_omega.txt
done


for sample in "g_qt1.auto" "s_qt1.auto"
do
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt bootstrap_alpha_Apr_test/${sample}.nonsyn.sfs_${i}.txt bootstrap_alpha_Apr_test/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cp bootstrap_alpha_Apr_test/${sample}.divergence_${i}.txt /ohta2/meng.yuan/ceratodon/dfe_a/divergence.txt

# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt
cut  -d' ' -f 6,8 est_alpha_omega.out>output_alpha/${sample}.alpha_omega_${i}.txt
done
cat output_alpha/${sample}.alpha_omega_*.txt>${sample}_bs_Apr18.alpha_omega.txt
done








# bootstrap_auto_Apr10 is comprimized need to be replaced
for sample in "g_specific.auto_p01" "s_specific.auto_p01"
do
/usr/local/bin/Rscript --vanilla sfs_bootstrap_auto_alpha.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_alpha_Apr11/
mv ${sample}*.divergence_*.txt bootstrap_alpha_Apr11/
done



# the sfs should also be updated
for sample in "g_specific.auto_p01" "s_specific.auto_p01"
do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt ${sample}.nonsyn.sfs.txt ${sample}.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cp ${sample}_divergence.txt ../dfe_a/divergence.txt

cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt # double check this
cut  -d' ' -f 6,8 est_alpha_omega.out>${sample}_real_Apr17.alpha_omega.txt
done

# see if the real data differ after changing the code


for sample in "g_specific.auto_p01" "s_specific.auto_p01"
do
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt bootstrap_alpha_Apr17/${sample}.nonsyn.sfs_${i}.txt bootstrap_alpha_Apr17/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cp bootstrap_alpha_Apr17/${sample}.divergence_${i}.txt /ohta2/meng.yuan/ceratodon/dfe_a/divergence.txt

# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt
cut  -d' ' -f 6,8 est_alpha_omega.out>output_alpha/${sample}.alpha_omega_${i}.txt
done
cat output_alpha/${sample}.alpha_omega_*.txt>${sample}_bs_Apr17.alpha_omega.txt
done






for i in "gs_ratio" "ss_ratio"
do
bcftools view -R ./bed/${i}.bed ../pixy/ceratodon_gDNA.auto.filt.syn.vcf.gz -O v -o ./vcf/${i}.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}.bed ../pixy/ceratodon_gDNA.auto.filt.nonsyn.vcf.gz -O v -o ./vcf/${i}.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.filt.syn.vcf  > ${i}.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.filt.nonsyn.vcf > ${i}.filt.nonsyn.vcf.txt
done



for sample in "gs_ratio" "ss_ratio"
do
/usr/local/bin/Rscript --vanilla sfs_auto_apr.R ${sample}
mv *.sfs.txt sfs.txt/
done


for sample in "gs_ratio" "ss_ratio"
do
/usr/local/bin/Rscript --vanilla sfs_bootstrap_auto.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_auto/
done



# to run next, 
# real data
for sample in "gs_ratio" "ss_ratio"
do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt sfs.txt/${sample}.nonsyn.sfs.txt sfs.txt/${sample}.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>${sample}_real.prop_muts.txt
done


# bootstrap data
for sample in "gs_ratio" "ss_ratio"
do
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt bootstrap_auto/${sample}.nonsyn.sfs_${i}.txt bootstrap_auto/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}_bs.prop_muts.txt
done
















