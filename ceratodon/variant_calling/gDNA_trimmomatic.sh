for i in $(ls gametophyteDNA/*.fastq.gz)
do 
fastqc $i -o gametophyteDNA_qc -t 16 
done

# leading and trailing values of three, window size of 10, quality score of 30,and minimum length of 40. We visually assessed the quality of the remaining reads using fastqc
for i in $(less gametophyteDNA.txt)
do
java -jar /ohta1/meng.yuan/apps/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
-phred33 -threads 16 gametophyteDNA/${i}_R1.fastq.gz \
gametophyteDNA/${i}_R2.fastq.gz gametophyteDNA_clean/${i}_1.clean_paired.fq.gz \
gametophyteDNA_clean/${i}_1.clean_unpaired.fq.gz gametophyteDNA_clean/${i}_2.clean_paired.fq.gz \
gametophyteDNA_clean/${i}_2.clean_unpaired.fq.gz \
ILLUMINACLIP:/ohta1/meng.yuan/apps/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:10:30 MINLEN:40
done

rm gametophyteDNA_clean/*.clean_unpaired.fq.gz


for i in $(ls gametophyteDNA_clean/*.clean_paired.fq.gz)
do 
fastqc $i -o gametophyteDNA_clean_qc -t 10 
done

