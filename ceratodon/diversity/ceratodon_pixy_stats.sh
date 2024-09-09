#################### get SFS scripts ready ####################
need to make sure invariant sites are ok

########### calculate allSite pi using pixy #####################
ceratodon_gDNA.V.filt.vcf.gz
# rename?

# need to ask stuart about the population file and samples
# do I  need o calculate pi only using the famale samples
scp ceratodon_gDNA.V.filt.vcf.gz meng.yuan@ohta.eeb.utoronto.ca:/ohta2/meng.yuan/ceratodon/pixy/
scp ceratodon_gDNA.U.filt.vcf.gz meng.yuan@ohta.eeb.utoronto.ca:/ohta2/meng.yuan/ceratodon/pixy/
scp ceratodon_gDNA.auto.filt.vcf.gz meng.yuan@ohta.eeb.utoronto.ca:/ohta2/meng.yuan/ceratodon/pixy/

# under pixy/
conda activate pixy
for i in "V" "U" "auto"
do
#tabix -p vcf ceratodon_gDNA.${i}.filt.vcf.gz
pixy --stats pi \
--vcf ceratodon_gDNA.${i}.filt.vcf.gz \
--populations popfile_${i}.txt \
--n_cores 20 \
--bed_file R40_GG1U_combined.${i}.bed \
--output_prefix ${i}_allSite_geneWise
#--bypass_invariant_check 'yes'
done

# sliding window
for i in "V" "U" "auto"
do
#tabix -p vcf ceratodon_gDNA.${i}.filt.vcf.gz
# use different window size
pixy --stats pi \
--vcf ceratodon_gDNA.${i}.filt.vcf.gz \
--populations popfile_${i}.txt \
--n_cores 20 \
--window_size 100000 \
--output_prefix ${i}_allSite_fixWind
#--bypass_invariant_check 'yes'
done


# warningsL can be ignored
# /ohta2/meng.yuan/apps/anaconda3/envs/pixy/lib/python3.8/site-packages/allel/io/vcf_read.py:1732: UserWarning: invalid INFO header: '##INFO=<ID=VDB,Number=1,Type=Float,Description="Variant Distance Bias for filtering splice-site artefacts in RNA-seq data (bigger is better)",Version="3">\n' warnings.warn('invalid INFO header: %r' % header)


# window size of 100,000 and jump of 10,000, excluded the chloroplast 
# for pi and tajD:  (NLocalities=5, NMales=8, NFemales=8).


# run window based not gene based pi

########### calculate syn and nonsyn pi using pixy ################
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

# R40.syn.sites1
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


# get syn and nonsyn subset VCfs from U V auto VCFs using bcftools -R option
sed -i 's/\s/\t/g' R40_GG1U_combined.syn.chrom_pos
sed -i 's/\s/\t/g' R40_GG1U_combined.nonsyn.chrom_pos

# test
# bcftools view -R R40_GG1U_combined.syn.chrom_pos ../pixy/ceratodon_gDNA.V.filt_Jan.vcf.gz >ceratodon_gDNA.${i}.filt_syn.vcf.gz 
# can go ahead once we know the VCfs are fine
# werid unzipping/zipping issue
# VCfs need to be indexed
# in pixy

# if this is too slow, can always use grep... just more extra steps
for i in "V" "U" 
do
# bgzip 
# tabix -p vcf ceratodon_gDNA.${i}.filt_Jan.vcf.gz
bcftools view -R ../siteType/R40_GG1U_combined.syn.chrom_pos ceratodon_gDNA.${i}.filt.vcf.gz  -O z -o ceratodon_gDNA.${i}.filt_syn.vcf.gz  
bcftools view -R ../siteType/R40_GG1U_combined.nonsyn.chrom_pos ceratodon_gDNA.${i}.filt.vcf.gz -O z -o ceratodon_gDNA.${i}.filt_nonsyn.vcf.gz 
done


# sort VCf positions
for i in "V" "U" 
do
i=auto
bcftools sort ceratodon_gDNA.${i}.filt_syn.vcf.gz -T /ohta2/meng.yuan/tmp -O z -o ceratodon_gDNA.${i}.filt.syn.vcf.gz
bcftools sort ceratodon_gDNA.${i}.filt_nonsyn.vcf.gz -T /ohta2/meng.yuan/tmp -O z -o ceratodon_gDNA.${i}.filt.nonsyn.vcf.gz
done


# conda activate pixy
# might need to simplify popfiles to interested pop or cobine some pops
# run this next
for i in "V" "U" 
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


# then use syn for the plot (can try nonsyn too just curious)
# will only need the syn pi filtes but could plot the nonsyn and definitely allSite one


########### calculte allSite tajD using popWindow (hopefully works)###############
filtering on variants might changed and that might affect tajD
otherwise the old TajD results can be used too?



########### checking VCFs ##############################################
# original vcf
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  Alaska_21.1.1_M1        Dur_19.2.8_M1   Dur_4.13.5_M2   Port_4_M2       Uconn_12.2.4_F2 Port_8_M1       Dur_13.8.1_M3   Equ_E13.E3.14_M1        Chile_1.1_M1
V       713762  .       A       T       216     PASS    DP=229;VDB=0.91233;SGB=101.518;RPB=0.910187;MQB=3.53237e-05;MQSB=0.150763;BQB=0.0735549;MQ0F=0.00436681;AC=1;AN=9;DP4=81,81,40,17;MQ=57 GT:PL   0:0,255 0:0,255 0:0,118 0:0,255 0:188,255       0:90,255        0:0,76  0:0,255 1:255,0

# my vcf
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  Alaska_21.1.1_M1        Dur_19.2.8_M1   Dur_4.13.5_M2   Port_4_M2       Uconn_12.2.4_F2 Port_8_M1       Dur_13.8.1_M3   Equ_E13.E3.14_M1        Chile_1.1_M1
V       713762  .       A       T       217.576 PASS    DP=188;VDB=0.617523;SGB=66.3615;RPBZ=0.0108449;MQBZ=-6.60115;MQSBZ=2.21567;BQBZ=-2.83222;NMBZ=13.0294;SCBZ=2.83822;FS=0;MQ0F=0.00531915;AC=1;AN=8;DP4=66,79,17,18;MQ=58 GT:PL:DP:AD:GQ  0:0,255:28:28,0:127     0:0,255:15:15,0:127     0:0,118:4:4,0:125       0:0,255:34:34,0:127     .:0,0:0:0,0:0   0:103,255:55:41,14:127  0:0,76:2:2,0:83 0:0,255:21:21,0:127     1:255,0:21:0,21:127


# need to look at IGV












