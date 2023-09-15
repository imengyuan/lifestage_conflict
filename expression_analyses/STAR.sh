# run on every sample
/ohta1/joanna.rifkin/STAR-2.7.6a/bin/Linux_x86_64/STAR --genomeDir /ohta1/bianca.sacchi/rhast_remap/genome --readFilesIn /ohta2/Rume
x/eQTL/Transcripts/NS.1583.002.NEBNext_dual_i7_B9---NEBNext_dual_i5_B9.70bMPR_R1.fastq.gz /ohta2/Rumex/eQTL/Transcripts/NS.1583.002.
NEBNext_dual_i7_B9---NEBNext_dual_i5_B9.70bMPR_R2.fastq.gz --readFilesCommand zcat --twopassMode Basic --twopass1readsN -1 --outFile
NamePrefix /ohta2/bianca.sacchi/eQTL_rumex_alignments/STAR/NS.1583.002.NEBNext_dual_i7_B9---NEBNext_dual_i5_B9.70bMPR_ --runThreadN
16