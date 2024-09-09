grep '#' eqtl20females.filt0329.vcf > eqtl20females.filt0329.vcf.header
grep 'LG' eqtl20females.filt0329.vcf > eqtl20females.filt0329.vcf.body

cut -f 1,2 eqtl20females.filt0329.vcf.body > eqtl20females.filt0329.vcf.body1
sed -i 's/\s/_/g' eqtl20females.filt0329.vcf.body1
paste -d '\t' eqtl20females.filt0329.vcf.body1 eqtl20females.filt0329.vcf.body >  eqtl20females.filt0329.vcf.body_pos
grep -wFf REF_LA.TE_filtered.syn.sites1 eqtl20females.filt0329.vcf.body_pos > eqtl20females.syn.filt0329.vcf.body
grep -wFf REF_LA.TE_filtered.nonsyn.sites1 eqtl20females.filt0329.vcf.body_pos > eqtl20females.nonsyn.filt0329.vcf.body

cut -f 2-30 eqtl20females.syn.filt0329.vcf.body > eqtl20females.syn.filt0329.vcf.body.ready
cut -f 2-30 eqtl20females.nonsyn.filt0329.vcf.body > eqtl20females.nonsyn.filt0329.vcf.body.ready

python3 getSFS.py eqtl20females.syn.filt0329.vcf.body.ready
python3 getSFS.py eqtl20females.nonsyn.filt0329.vcf.body.ready

cat eqtl20females.filt0329.vcf.header eqtl20females.syn.filt0329.vcf.body.ready | bgzip > eqtl20females.syn.filt0329.vcf.gz
tabix -p vcf eqtl20females.syn.filt0329.vcf.gz

