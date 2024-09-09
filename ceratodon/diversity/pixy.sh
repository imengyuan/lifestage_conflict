
python3 /ohta1/meng.yuan/apps/genomics_general/codingSiteTypes.py -a ../genome/R40_GG1U_combined.gff -f gff3 -o R40_GG1U_combined.siteTypes -r ../genome/R40_GG1U_combined.fa --ignoreConflicts

python3 siteType.py
# f_in = open("R40_GG1U_combined.siteTypes", "r")
# out_file1 = "R40_GG1U_combined.nonsyn.sites"
# out_file2 = "R40_GG1U_combined.syn.sites"

# syn, nonsyn
cut -f 1,2 R40_GG1U_combined.syn.sites>R40_GG1U_combined.syn.chrom_pos
#sed -i 's/\s/_/g' R40_GG1U_combined.syn.sites1
cut -f 1,2 R40_GG1U_combined.nonsyn.sites>R40_GG1U_combined.nonsyn.chrom_pos
#sed -i 's/\s/_/g' R40_GG1U_combined.nonsyn.sites1

i=R40_GG1U_combined.syn.chrom_pos
i=R40_GG1U_combined.nonsyn.chrom_pos # could've run on the original file
sed -i 's/CM026421\.1/Chr01/g' ${i}
sed -i 's/CM026422\.1/Chr02/g' ${i}
sed -i 's/CM026423\.1/Chr03/g' ${i}
sed -i 's/CM026424\.1/Chr04/g' ${i}
sed -i 's/CM026425\.1/Chr05/g' ${i}
sed -i 's/CM026426\.1/V/g' ${i}
sed -i 's/CM026427\.1/Chr06/g' ${i}
sed -i 's/CM026428\.1/Chr07/g' ${i}
sed -i 's/CM026429\.1/Chr08/g' ${i}
sed -i 's/CM026430\.1/Chr09/g' ${i}
sed -i 's/CM026431\.1/Chr10/g' ${i}
sed -i 's/CM026432\.1/Chr11/g' ${i}
sed -i 's/CM026433\.1/Chr12/g' ${i}
sed -i 's/CM026446\.1/U/g' ${i}

sed -i 's/\s/\t/g' R40_GG1U_combined.syn.chrom_pos
sed -i 's/\s/\t/g' R40_GG1U_combined.nonsyn.chrom_pos



for i in "V" "U" "auto"
do
# bgzip 
# tabix -p vcf ceratodon_gDNA.${i}.filt_Jan.vcf.gz
bcftools view -R ../siteType/R40_GG1U_combined.syn.chrom_pos \
ceratodon_gDNA.${i}.filt.vcf.gz  -O z -o ceratodon_gDNA.${i}.filt_syn.vcf.gz  
bcftools view -R ../siteType/R40_GG1U_combined.nonsyn.chrom_pos \
ceratodon_gDNA.${i}.filt.vcf.gz -O z -o ceratodon_gDNA.${i}.filt_nonsyn.vcf.gz 
done


conda activate pixy

# pi for all sites
for i in "V" "U" "auto"
do
tabix -p vcf ceratodon_gDNA.${i}.filt.vcf.gz
pixy --stats pi \
--vcf ceratodon_gDNA.${i}.filt.vcf.gz \
--populations popfile_${i}.txt \
--n_cores 20 \
--bed_file R40_GG1U_combined.${i}.bed \
--output_prefix ${i}_allSite_geneWise
#--bypass_invariant_check 'yes'
done

# pi for syn sites
# sort VCf positions
for i in "V" "U" "auto"
do
bcftools sort ceratodon_gDNA.${i}.filt_syn.vcf.gz -T /ohta2/meng.yuan/tmp \
-O z -o ceratodon_gDNA.${i}.filt.syn.vcf.gz
bcftools sort ceratodon_gDNA.${i}.filt_nonsyn.vcf.gz -T /ohta2/meng.yuan/tmp \
-O z -o ceratodon_gDNA.${i}.filt.nonsyn.vcf.gz
done

for i in "V" "U" "auto"
do
tabix -p vcf ceratodon_gDNA.${i}.filt.syn.vcf.gz
tabix -p vcf ceratodon_gDNA.${i}.filt.nonsyn.vcf.gz

pixy --stats pi \
--vcf ceratodon_gDNA.${i}.filt.syn.vcf.gz \
--populations popfile_${i}.txt \
--n_cores 20 \
--bed_file R40_GG1U_combined.${i}.bed \
--output_prefix ${i}_syn_geneWise

pixy --stats pi \
--vcf ceratodon_gDNA.${i}.filt.nonsyn.vcf.gz \
--populations popfile_${i}.txt \
--n_cores 20 \
--bed_file R40_GG1U_combined.${i}.bed \
--output_prefix ${i}_nonsyn_geneWise

done


