# same all LGs
/ohta1/apps/freebayes/freebayes \
    --fasta-reference /ohta1/bianca.sacchi/rhast_remap/genome/REF_LA.fa \
    --bam-list /ohta2/bianca.sacchi/eQTL_rumex_variantcalling/females20.txt \
    --region LG4 \
    --report-monomorphic \
    --use-best-n-alleles 4 \
    --genotype-qualities \
    --skip-coverage 1000 \
    --vcf eqtl20females_lg4.vcf