# get input VCF.txt for generating SFS
# /ohta2/meng.yuan/rumex/diversity2022/VCFs
# l_specific_noTE_DE.bed
# p_specific_noTE_DE.bed
#for i in "p_specific_noTE_DE" "l_specific_noTE_DE"
for i in ""
do
bcftools view -R ${i}.bed eqtl20females.syn.filt0329.vcf.gz -O v -o ${i}.syn.filt0329.vcf --threads 30 
bcftools view -R ${i}.bed eqtl20females.nonsyn.filt0329.vcf.gz -O v -o ${i}.nonsyn.filt0329.vcf --threads 30 
done


for i in "p_specific_noTE_DE" "l_specific_noTE_DE"
do
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ${i}.syn.filt0329.vcf |sed 's/\//\t/g' > ${i}.syn.filt0329.vcf.txt
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ${i}.nonsyn.filt0329.vcf |sed 's/\//\t/g' > ${i}.nonsyn.filt0329.vcf.txt
done

mv l_specific_noTE_DE*.vcf.txt ../bootstrap/
mv p_specific_noTE_DE*.vcf.txt ../bootstrap/

# get SFS
# /ohta2/meng.yuan/rumex/diversity2022/bootstrap
for sample in "p_specific_noTE_DE" "l_specific_noTE_DE"
do
/usr/local/bin/Rscript --vanilla sfs.R ${sample}
done



for sample in "p_specific_noTE_DE" "l_specific_noTE_DE"
do
/usr/local/bin/Rscript --vanilla sfs_bootstrap.R ${sample}
mv ${sample}*.sfs_*.txt bootstrap_specific/
done


# run DFE
# real data
for sample in "p_specific_noTE_DE" "l_specific_noTE_DE"
do
cd /ohta2/meng.yuan/rumex/diversity2022/bootstrap
cat head.txt ${sample}.nonsyn.sfs.txt ${sample}.syn.sfs.txt>../dfe_a/sfs_expressed_test.txt
cd /ohta2/meng.yuan/rumex/diversity2022/dfe_a/
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>${sample}_real.prop_muts.txt
done

# rerun this too
# bootstrap data
for sample in "p_specific_noTE_DE" "l_specific_noTE_DE"
do
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/rumex/diversity2022/bootstrap
cat head.txt bootstrap_specific/${sample}.nonsyn.sfs_${i}.txt bootstrap_specific/${sample}.syn.sfs_${i}.txt>../dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/rumex/diversity2022/dfe_a/
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}_bs.prop_muts.txt
done

