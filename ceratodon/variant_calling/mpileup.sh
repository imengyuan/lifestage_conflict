#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=20:00:00
#SBATCH --job-name mpileup_gDNA
module load vcftools
module load samtools
ref=/scratch/w/wrighste/yuanmeng/ceratodon/genome/R40_GG1U_combined.fa
bamlist=/scratch/w/wrighste/yuanmeng/ceratodon/gDNA_bam_list.txt
output=/scratch/w/wrighste/yuanmeng/ceratodon/VCF/ceratodon_gDNA_Jan10.vcf.gz
bcftools=/scratch/w/wrighste/yuanmeng/apps/bcftools/bcftools

bcftools mpileup -B -I -f ${ref} -b ${bamlist} | bcftools call --ploidy 1 -m -O z -o ${output}
