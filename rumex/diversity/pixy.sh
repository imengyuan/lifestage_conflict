python3 getVCFs.py eqtl20females.filt0329.vcf REF_LA.TE_filtered.siteTypes

bgzip eqtl20females.filt0329.syn.vcf
tabix eqtl20females.filt0329.syn.vcf.gz
bgzip eqtl20females.filt0329.nonsyn.vcf
tabix eqtl20females.filt0329.nonsyn.vcf.gz


# get syn and nonsyn VCF & SFS the old way
grep '#' eqtl20females.filt0329.vcf > eqtl20females.filt0329.vcf.header
grep 'LG' eqtl20females.filt0329.vcf > eqtl20females.filt0329.vcf.body

cut -f 1,2 eqtl20females.filt0329.vcf.body > eqtl20females.filt0329.vcf.body1
sed -i 's/\s/_/g' eqtl20females.filt0329.vcf.body1
paste -d '\t' eqtl20females.filt0329.vcf.body1 eqtl20females.filt0329.vcf.body >  eqtl20females.filt0329.vcf.body_pos
grep -wFf REF_LA.TE_filtered.syn.sites1 eqtl20females.filt0329.vcf.body_pos > eqtl20females.syn.filt0329.vcf.body
grep -wFf REF_LA.TE_filtered.nonsyn.sites1 eqtl20females.filt0329.vcf.body_pos > eqtl20females.nonsyn.filt0329.vcf.body

cut -f 2-30 eqtl20females.syn.filt0329.vcf.body > eqtl20females.syn.filt0329.vcf.body.ready
cut -f 2-30 eqtl20females.nonsyn.filt0329.vcf.body > eqtl20females.nonsyn.filt0329.vcf.body.ready

# python3 getSFS.py eqtl20females.syn.filt0329.vcf.body.ready
# python3 getSFS.py eqtl20females.nonsyn.filt0329.vcf.body.ready

cat eqtl20females.filt0329.vcf.header eqtl20females.syn.filt0329.vcf.body.ready | bgzip > eqtl20females.syn.filt0329.vcf.gz
tabix -p vcf eqtl20females.syn.filt0329.vcf.gz

cat eqtl20females.filt0329.vcf.header eqtl20females.nonsyn.filt0329.vcf.body.ready | bgzip > eqtl20females.nonsyn.filt0329.vcf.gz
tabix -p vcf eqtl20females.nonsyn.filt0329.vcf.gz


# run pixy
# gene by gene pi (syn)
pixy --stats pi \
--vcf /ohta2/meng.yuan/rumex/diversity2022/VCFs/eqtl20females.syn.filt0329.vcf.gz \
--populations popfile.txt \
--n_cores 30 \
--bed_file /ohta2/meng.yuan/rumex/diversity2022/pixy/REF_LA_filtered_annotation.onlygenes.bed \
--output_prefix pixy_pi_syn.0329.genewise

# gene by gene pi (nonsyn)
pixy --stats pi \
--vcf /ohta2/meng.yuan/rumex/diversity2022/VCFs/eqtl20females.nonsyn.filt0329.vcf.gz \
--populations popfile.txt \
--n_cores 30 \
--bed_file /ohta2/meng.yuan/rumex/diversity2022/pixy/REF_LA_filtered_annotation.onlygenes.bed \
--output_prefix pixy_pi_nonsyn.0329.genewise



