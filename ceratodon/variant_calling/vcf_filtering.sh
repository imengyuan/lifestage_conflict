# subset to U, V and autosome
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=3:00:00
#SBATCH --job-name ceratodon_separateVCFs
module load vcftools
module load samtools
vcf_in=/scratch/w/wrighste/yuanmeng/ceratodon/VCF/ceratodon_gDNA.vcf.gz
vcf_renamed=/scratch/w/wrighste/yuanmeng/ceratodon/VCF/ceratodon_gDNA_renameed.vcf.gz
vcf_auto=/scratch/w/wrighste/yuanmeng/ceratodon/VCF/ceratodon_gDNA.auto.vcf.gz
vcf_U=/scratch/w/wrighste/yuanmeng/ceratodon/VCF/ceratodon_gDNA.U.vcf.gz
vcf_V=/scratch/w/wrighste/yuanmeng/ceratodon/VCF/ceratodon_gDNA.V.vcf.gz


# first rename chromosomes
bcftools annotate --rename-chrs /scratch/w/wrighste/yuanmeng/ceratodon/chr_name_conv.txt ${vcf_in} | bgzip > ${vcf_renamed}

tabix ${vcf_renamed}

## auto 18 samples
bcftools view -r Chr01,Chr02,Chr03,Chr04,Chr05,Chr06,Chr07,Chr08,Chr09,Chr10,Chr11,Chr12 -s Alaska_21.1.1_M1,Dur_19.2.8_M1,Dur_4.13.5_M2,Port_4_M2,Uconn_12.2.4_F2,Port_8_M1,Dur_13.8.1_M3,Equ_E13.E3.14_M1,Alaska_21.1.8_F1,Dur_16.6.2_F1,Dur_4.13.7_F2,Port_11_F2,Uconn_15.12.12_F1,Dur_13.8.10_F3,Equ_E13.E3.1_F1,Port_7_F1,Chile_1.1_M1,Chile_2.12_F1 ${vcf_renamed} | bgzip > ${vcf_auto}

## U 9 samples
bcftools view -r V -s Alaska_21.1.1_M1,Dur_19.2.8_M1,Dur_4.13.5_M2,Port_4_M2,Uconn_12.2.4_F2,Port_8_M1,Dur_13.8.1_M3,Equ_E13.E3.14_M1,Chile_1.1_M1 ${vcf_renamed} | bgzip > ${vcf_V}

## V 9 samples
bcftools view -r U -s Alaska_21.1.8_F1,Dur_16.6.2_F1,Dur_4.13.7_F2,Port_11_F2,Uconn_15.12.12_F1,Dur_13.8.10_F3,Equ_E13.E3.1_F1,Port_7_F1,Chile_2.12_F1 ${vcf_renamed} |  bgzip > ${vcf_U}


# filter auto VCF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=3:00:00
#SBATCH --job-name ceratodon_filt_auto
module load vcftools
module load samtools
vcf_in=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto.vcf.gz
vcf_in_filt1=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto_filt1.vcf.gz
vcf_invariant1=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto_invariant1.vcf.gz
vcf_invariant2=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto_invariant2.vcf.gz
vcf_invariant=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto_invariant.vcf.gz
vcf_variant=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto_variant.vcf.gz
vcf_out=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.auto.filt.vcf.gz

# filter on dp and missingness
bcftools filter -e 'INFO/DP<5' ${vcf_in} -O z -o ${vcf_in_filt1} 

# invariant
bcftools filter -i 'ALT="."' ${vcf_in_filt1} -O z -o ${vcf_invariant1}
bcftools view --max-ac 0:minor -M2 ${vcf_in_filt1}  -O z -o ${vcf_invariant2}

tabix ${vcf_invariant1}
tabix ${vcf_invariant2}

bcftools concat --allow-overlaps ${vcf_invariant1} ${vcf_invariant2} |  \
bcftools filter -e 'F_MISSING > 0.2' -O z -o ${vcf_invariant}

# variant 
bcftools filter -e 'QUAL<30 && MQ<30' ${vcf_in_filt1} | \
bcftools view -m2 -M2 -v snps |bcftools filter -e 'F_MISSING > 0.2' -O z -o ${vcf_variant}

tabix ${vcf_variant}
tabix ${vcf_invariant}

bcftools concat --allow-overlaps ${vcf_invariant} ${vcf_variant} -O z -o ${vcf_out}


# filter U VCF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=3:00:00
#SBATCH --job-name ceratodon_filt_U
vcf_in=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U.vcf.gz
vcf_in_filt1=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U_filt1.vcf.gz
vcf_invariant1=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U_invariant1.vcf.gz
vcf_invariant2=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U_invariant2.vcf.gz
vcf_invariant=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U_invariant.vcf.gz
vcf_variant=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U_variant.vcf.gz
vcf_out=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.U.filt.vcf.gz

# filter on dp and missingness
bcftools filter -e 'INFO/DP<5' ${vcf_in} -O z -o ${vcf_in_filt1} 

# invariant
bcftools filter -i 'ALT="."' ${vcf_in_filt1} -O z -o ${vcf_invariant1}
bcftools view --max-ac 0:minor -M2 ${vcf_in_filt1}  -O z -o ${vcf_invariant2}

tabix ${vcf_invariant1}
tabix ${vcf_invariant2}

bcftools concat --allow-overlaps ${vcf_invariant1} ${vcf_invariant2} |  \
bcftools filter -e 'F_MISSING > 0.2' -O z -o ${vcf_invariant}

# variant 
bcftools filter -e 'QUAL<30 && MQ<30' ${vcf_in_filt1} | \
bcftools view -m2 -M2 -v snps |bcftools filter -e 'F_MISSING > 0.2' -O z -o ${vcf_variant}

tabix ${vcf_variant}
tabix ${vcf_invariant}

bcftools concat --allow-overlaps ${vcf_invariant} ${vcf_variant} -O z -o ${vcf_out}


# filter V VCF
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=3:00:00
#SBATCH --job-name ceratodon_filt_V
vcf_in=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V.vcf.gz
vcf_in_filt1=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V_filt1.vcf.gz
vcf_invariant1=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V_invariant1.vcf.gz
vcf_invariant2=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V_invariant2.vcf.gz
vcf_invariant=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V_invariant.vcf.gz
vcf_variant=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V_variant.vcf.gz
vcf_out=/scratch/w/wrighste/yuanmeng/ceratodon/VCF_Feb/ceratodon_gDNA.V.filt.vcf.gz
# filter on dp and missingness
bcftools filter -e 'INFO/DP<5' ${vcf_in} -O z -o ${vcf_in_filt1} 

# invariant
bcftools filter -i 'ALT="."' ${vcf_in_filt1} -O z -o ${vcf_invariant1}
bcftools view --max-ac 0:minor -M2 ${vcf_in_filt1}  -O z -o ${vcf_invariant2}

tabix ${vcf_invariant1}
tabix ${vcf_invariant2}

bcftools concat --allow-overlaps ${vcf_invariant1} ${vcf_invariant2} |  \
bcftools filter -e 'F_MISSING > 0.2' -O z -o ${vcf_invariant}

# variant 
bcftools filter -e 'QUAL<30 && MQ<30' ${vcf_in_filt1} | \
bcftools view -m2 -M2 -v snps |bcftools filter -e 'F_MISSING > 0.2' -O z -o ${vcf_variant}

tabix ${vcf_variant}
tabix ${vcf_invariant}

bcftools concat --allow-overlaps ${vcf_invariant} ${vcf_variant} -O z -o ${vcf_out}




