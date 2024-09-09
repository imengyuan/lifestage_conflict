# without boostrap, run for 8 groups
# under /ohta2/meng.yuan/ceratodon/VCF_genes
for i in "g" "s"
do
for j in "qt1" "qt2" "qt3" "qt4"
do
bcftools view -R ./bed/${i}_${j}_auto.bed ../pixy/ceratodon_gDNA.auto.filt.syn.vcf.gz -O v -o ./vcf/${i}_${j}.auto.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}_${j}_auto.bed ../pixy/ceratodon_gDNA.auto.filt.nonsyn.vcf.gz -O v -o ./vcf/${i}_${j}.auto.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}_${j}.auto.filt.syn.vcf  > ${i}_${j}.auto.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}_${j}.auto.filt.nonsyn.vcf > ${i}_${j}.auto.filt.nonsyn.vcf.txt
done
done

# real data
# sample=g_specific.auto_p01
# sample=s_specific.auto_p01
for i in "g" "s"
do
for j in "qt1" "qt2" "qt3" "qt4"
do
/usr/local/bin/Rscript --vanilla sfs_auto_apr.R ${i}_${j}.auto
done
done


for i in "g" "s"
do
for j in "qt1" "qt2" "qt3" "qt4"
do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt sfs.txt/${i}_${j}.auto.nonsyn.sfs.txt sfs.txt/${i}_${j}.auto.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>${i}_${j}.auto_real.prop_muts.txt
done
done

# should write r code to replace excel steps


# bootstrap data
for i in "g" "s"
do
for j in "qt1" "qt2" "qt3" "qt4"
do
/usr/local/bin/Rscript --vanilla sfs_bootstrap_auto.R ${i}_${j}.auto
mv ${i}_${j}.auto*.sfs_*.txt bootstrap_auto_qt/
done
done





# for i in {1..200}; do
# # generate sfs.txt for input
# cd /ohta2/meng.yuan/ceratodon/VCF_genes/
# cat head.txt bootstrap_UV/${sample}.nonsyn.sfs_${i}.txt bootstrap_UV/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# # run est_dfe
# cd /ohta2/meng.yuan/ceratodon/dfe_a
# est_dfe -c est_dfe_configfile_neut.txt
# est_dfe -c est_dfe_configfile_sel.txt
# prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
# cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
# done
# cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts_bs.txt



for i in "g" "s"
do
for j in "qt1" "qt2" "qt3" "qt4"
do

for n in {1..200}; do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt bootstrap_auto_qt/${i}_${j}.auto.nonsyn.sfs_${n}.txt bootstrap_auto_qt/${i}_${j}.auto.syn.sfs_${n}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${i}_${j}.auto.prop_muts_${n}.txt
done
cat output/${i}_${j}.auto.prop_muts_*.txt>${i}_${j}.auto_bs.prop_muts.txt

done
done

#running too fast??





