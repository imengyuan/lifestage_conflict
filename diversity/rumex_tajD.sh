
# tajD syn in rumex
python3 /ohta1/meng.yuan/apps/genomics_general/VCF_processing/parseVCFs.py -i /ohta2/meng.yuan/rumex/diversity2022/VCFs/eqtl20females.syn.filt0329.vcf.gz    --ploidyMismatchToMissing --threads 30 | bgzip > eqtl20females.syn.filt0329.geno.gz


python3 /ohta1/meng.yuan/apps/genomics_general/popgenWindows.py --windType predefined --windCoords /ohta2/meng.yuan/rumex/diversity2022/pixy/REF_LA_filtered_annotation.onlygenes.bed -g eqtl20females.syn.filt0329.geno.gz -o rumex_tajD.filt0329_syn.csv.gz -f phased -T 30 -p TX --popsFile popfile.txt --analysis popFreq --writeFailedWindows


# tajD nonsyn in rumex
python3 /ohta1/meng.yuan/apps/genomics_general/VCF_processing/parseVCFs.py -i /ohta2/meng.yuan/rumex/diversity2022/VCFs/eqtl20females.nonsyn.filt0329.vcf.gz    --ploidyMismatchToMissing --threads 30 | bgzip > eqtl20females.nonsyn.filt0329.geno.gz


python3 /ohta1/meng.yuan/apps/genomics_general/popgenWindows.py --windType predefined --windCoords /ohta2/meng.yuan/rumex/diversity2022/pixy/REF_LA_filtered_annotation.onlygenes.bed -g eqtl20females.nonsyn.filt0329.geno.gz -o rumex_tajD.filt0329_nonsyn.csv.gz -f phased -T 30 -p TX --popsFile popfile.txt --analysis popFreq --writeFailedWindows