# files needed
for i in "V" "U" 
ceratodon_gDNA.${i}.filt.syn.vcf.gz
ceratodon_gDNA.${i}.filt.nonsyn.vcf.gz 

# .bed files ready for g and s specific genes etc.
g_specific.bed      g_specific_V.bed    s_specific.bed      s_specific_V.bed
g_specific_U.bed    g_specific_auto.bed s_specific_U.bed    s_specific_auto.bed

# go on with this group and repeat with new .bed later

########### run DFE-alpha for purifying selection #################

# for downstream R bootstrapping, do U, V and auto need to be separate,
# if not many sites doesn't make sense to be a single set, but U and V have a lot of genes 

# bcftools query -f '%CHROM\t%POS[\t%GT]\n' test2.vcf | head -100 |sed 's/\//\t/g' | sed 's/\./NA/g'> test.vcf.txt
# under /ohta2/meng.yuan/ceratodon/VCF_genes
for i in "g_specific" "s_specific"
do
bcftools view -R ./bed/${i}_U.bed ../pixy/ceratodon_gDNA.U.filt.syn.vcf.gz -O v -o ./vcf/${i}.U.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}_U.bed ../pixy/ceratodon_gDNA.U.filt.nonsyn.vcf.gz -O v -o ./vcf/${i}.U.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.U.filt.syn.vcf |sed 's/\//\t/g' > ${i}.U.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.U.filt.nonsyn.vcf |sed 's/\//\t/g' > ${i}.U.filt.nonsyn.vcf.txt
done

for i in "g_specific" "s_specific"
do
bcftools view -R ./bed/${i}_V.bed ../pixy/ceratodon_gDNA.V.filt.syn.vcf.gz -O v -o ./vcf/${i}.V.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}_V.bed ../pixy/ceratodon_gDNA.V.filt.nonsyn.vcf.gz -O v -o ./vcf/${i}.V.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.V.filt.syn.vcf |sed 's/\//\t/g' > ${i}.V.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.V.filt.nonsyn.vcf |sed 's/\//\t/g' > ${i}.V.filt.nonsyn.vcf.txt
done

# haploid genotypes, no need to sed 
# Mar 24
for i in "g_specific" "s_specific"
do
bcftools view -R ./bed/${i}_auto_p01.bed ../pixy/ceratodon_gDNA.auto.filt.syn.vcf.gz -O v -o ./vcf/${i}.auto_p01.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}_auto_p01.bed ../pixy/ceratodon_gDNA.auto.filt.nonsyn.vcf.gz -O v -o ./vcf/${i}.auto_p01.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.auto_p01.filt.syn.vcf  > ${i}.auto_p01.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.auto_p01.filt.nonsyn.vcf > ${i}.auto_p01.filt.nonsyn.vcf.txt
done


for i in "g_specific" "s_specific"
do
bcftools view -R ./bed/${i}_auto.bed ../pixy/ceratodon_gDNA.auto.filt.syn.vcf.gz -O v -o ./vcf/${i}.auto.filt.syn.vcf --threads 30 
bcftools view -R ./bed/${i}_auto.bed ../pixy/ceratodon_gDNA.auto.filt.nonsyn.vcf.gz -O v -o ./vcf/${i}.auto.filt.nonsyn.vcf --threads 30 

bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.auto.filt.syn.vcf  > ${i}.auto.filt.syn.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ./vcf/${i}.auto.filt.nonsyn.vcf > ${i}.auto.filt.nonsyn.vcf.txt
done


# under /VCF_genes/sfs_bs, run bootstrapping to get sfs
# run next, use 20 iterations to test, done and really fast
sample=g_specific.V

sample=s_specific.V

/usr/local/bin/Rscript --vanilla sfs_bootstrap.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_V/



# for a test
# tpm set totally for a test
for sample in "g_specific.V" "g_specific.U" "s_specific.V" "s_specific.U"
do
/usr/local/bin/Rscript --vanilla sfs_UV.R ${sample}
done

for sample in "g_specific.V" "g_specific.U" "s_specific.V" "s_specific.U"
do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt sfs.txt/${sample}.nonsyn.sfs.txt sfs.txt/${sample}.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>${sample}.prop_muts_real.txt
done	




sample=g_specific.auto_p01
sample=s_specific.auto_p01

/usr/local/bin/Rscript --vanilla sfs_bootstrap_auto.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_auto/

/usr/local/bin/Rscript --vanilla sfs_auto.R ${sample}

# just for a test
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt s_specific.auto_p01.nonsyn.sfs.txt s_specific.auto_p01.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out



for sample in "g_specific.V" "g_specific.U" "s_specific.V" "s_specific.U"

sample=g_specific.V
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt bootstrap_UV/${sample}.nonsyn.sfs_${i}.txt bootstrap_UV/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts_bs.txt





# Mar 26
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
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts.txt

# use the real data
# so many DFE options in graph
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt s_specific.auto_p01.nonsyn.sfs.txt s_specific.auto_p01.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out

0.472265 0.311213 0.212295 0.004227

cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt g_specific.auto_p01.nonsyn.sfs.txt s_specific.auto_p01.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out




# /ohta2/meng.yuan/rumex/diversity2022/dfe_a/
# move and put back if needed /ohta2/meng.yuan/rumex/diversity2022/dfe_a/downloaded_data

sample=g_specific.U
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt bootstrap/${sample}.nonsyn.sfs_${i}.txt bootstrap/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts.txt



# download for plots
/ohta2/meng.yuan/rumex/diversity2022/dfe_a/pollen_specific.prop_muts.txt

# auto, U and V are separate, just have them all separate?
use the fake tpm U nad V genes # need to change the code to have equal leangth of sfs



########### run DFE-alpha for positive selection (alpha, omega) #################
# for real samples
for sample in "g_specific.auto_p01" "s_specific.auto_p01"
do
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head_auto.txt sfs.txt/${sample}.nonsyn.sfs.txt sfs.txt/${sample}.syn.sfs.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
cp divergence.txt/${sample}_divergence.txt ../dfe_a/divergence.txt

cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt # double check this
cut  -d' ' -f 6,8 est_alpha_omega.out>${sample}_real.alpha_omega.txt
done


# data_path_1     /ohta2/meng.yuan/ceratodon/dfe_a/downloaded_data/data
# divergence_file         divergence.txt
# est_alpha_omega_results_file    est_alpha_omega.out
# est_dfe_results_file    results_dir_sel/est_dfe.out
# neut_egf_file           results_dir_neut/neut_egf.out
# sel_egf_file            results_dir_sel/sel_egf.out
# do_jukes_cantor         1
# remove_poly             0


est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt
cat est_alpha_omega.out
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out


# for bootstrapping
# for leaf
sample=pollen_specific
sample=leaf_specific
/usr/local/bin/Rscript --vanilla sfs_bootstrap_alpha.R ${sample}

# somehow doesnt work, skip to below
sample=pollen_specific
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/rumex/diversity2022/bootstrap
cat head.txt ${sample}.nonsyn.sfs_${i}.txt ${sample}.syn.sfs_${i}.txt>../dfe_a/sfs_expressed_test.txt
cp ${sample}_divergence_${i}.txt ../dfe_a/divergence.txt

# run est_dfe
cd /ohta2/meng.yuan/rumex/diversity2022/dfe_a/
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
est_alpha_omega -c est_alpha_omega_configfile.txt

cut  -d' ' -f 6,8 est_alpha_omega.out>${sample}.alpha_omega_${i}.txt
done
cat ${sample}.alpha_omega_*.txt>${sample}.alpha_omega.txt



# 1 number_of_selected_sites number_of_selected_differences
# 0 number_of_neutral_sites number_of_neutral_differences











