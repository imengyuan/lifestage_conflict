bcftools concat -O v -o eqtl20females.all.vcf --threads 16 eqtl20females_lg1.vcf eqtl20females_lg2.vcf eqtl20females_lg3.vcf eqtl20females_lg4.vcf eqtl20females_lg5.vcf
e

# create a filtered VCF containing only variant sites
vcftools --gzvcf eqtl20females.all.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--minQ 30 \
--min-alleles 2 --max-alleles 2 \
--min-meanDP 10 \
--max-meanDP 40 \
--recode --stdout | bgzip -c > eqtl20females_variant.vcf.gz


# filter invariant sites
vcftools --gzvcf eqtl20females.all.vcf.gz \
--max-maf 0 \
--max-alleles 2 \
--remove-indels \
--max-missing 0.8 \
--min-meanDP 10 \
--max-meanDP 40 \
--recode --stdout | bgzip -c > eqtl20females_invariant.vcf.gz

# index both vcfs using tabix
tabix eqtl20females_invariant.vcf.gz
tabix eqtl20females_variant.vcf.gz

# combine the two VCFs using bcftools concat
bcftools concat \
--allow-overlaps \
eqtl20females_invariant.vcf.gz eqtl20females_variant.vcf.gz \
-O z -o eqtl20females.filt0329.vcf.gz

# minor allele frequency =0 but it's not va







