python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt   -o rumex_scan_DAF_May9.txt --spect rumex_spect_DAF_May9.txt

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt --getSpect --spect rumex_spect_DAF_May9.txt
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt  -o rumex_scan_DAF_May9.txt --spect rumex_spect_DAF_May9.txt

# rumex on each LG
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i rumex_input_DAF_Jul6_LG${i}.txt  -o rumex_scan_DAF_Jul6_LG${i}.txt --spect rumex_spect_DAF_May9.txt --findBal

#nov get 14 running and renice them
python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01.txt  -o ceratodon_scan_DAF_Chr01.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_chr02.txt  -o ceratodon_scan_DAF_chr02.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001


grep 'Chr01' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr01.txt



grep 'Chr02' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr02.txt
grep 'Chr03' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr03.txt
grep 'Chr04' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr04.txt
grep 'Chr05' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr05.txt
grep 'Chr06' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr06.txt
grep 'Chr07' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr07.txt
grep 'Chr08' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr08.txt
grep 'Chr09' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr09.txt
grep 'Chr10' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr10.txt
grep 'Chr11' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr11.txt
grep 'Chr12' ceratodon_input_DAF_chrom.txt | cut -f 2-5 > ceratodon_input_DAF_Chr12.txt

wc -l ceratodon_input_DAF_Chr*.txt

   838285 ceratodon_input_DAF_Chr01.txt
   885111 ceratodon_input_DAF_Chr02.txt
   765845 ceratodon_input_DAF_Chr03.txt
   748661 ceratodon_input_DAF_Chr04.txt
   654953 ceratodon_input_DAF_Chr05.txt
   603157 ceratodon_input_DAF_Chr06.txt
   526719 ceratodon_input_DAF_Chr07.txt
   520023 ceratodon_input_DAF_Chr08.txt
   605443 ceratodon_input_DAF_Chr09.txt
   511625 ceratodon_input_DAF_Chr10.txt
   590199 ceratodon_input_DAF_Chr11.txt
   493881 ceratodon_input_DAF_Chr12.txt
  
  7743902 total

physPos genPos x n

sed -i '1i\physPos\tgenPos\tx\tn' ceratodon_input_DAF_Chr07.txt

head -n 1000001 ceratodon_input_DAF.txt > ceratodon_input_DAF_1mb.txt

python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_1mb.txt  -o ceratodon_scan_DAF_1mb.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001  --findBal

#cat ${bamlist} | parallel -j ${cores} 'bcftools mpileup -B -I -f ${ref} -b {} | bcftools call -m -O z -o {}.vcf.gz'



cat chrom12_list.txt | parallel -j 10 'python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr12_{}.txt -o ceratodon_scan_DAF_Chr12_{}.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt


cat chrom02_list.txt | parallel -j 20 'python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr02_{}.txt -o ceratodon_scan_DAF_Chr02_{}.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt


scp meng.yuan@ohta.eeb.utoronto.ca:/ohta2/meng.yuan/ceratodon/ballermix/ceratodon_spect_DAF.txt ./



fix header then redo

ENV=/scratch/w/wrighste/yuanmeng
virtualenv --no-download $ENV
source $ENV/bin/activate

source ~/.virtualenvs/myenv/bin/activate


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=8:00:00
#SBATCH --job-name scan_chrom2
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --upgrade pip
pip install numpy 
pip install scipy

cat chrom01_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01_{}.txt -o ceratodon_scan_DAF_Chr01_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal'


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=11:00:00
#SBATCH --job-name scan_chrom01
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom12_list.txt | parallel -j 25 --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr12_{}.txt -o ceratodon_scan_DAF_Chr12_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal > out.{}.txt' 





#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name scan_chrom11
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom11_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr11_{}.txt -o ceratodon_scan_DAF_Chr11_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name scan_chrom10
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom10_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr10_{}.txt -o ceratodon_scan_DAF_Chr10_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt



#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name scan_chrom09
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom09_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr09_{}.txt -o ceratodon_scan_DAF_Chr09_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name scan_chrom08
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom08_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr08_{}.txt -o ceratodon_scan_DAF_Chr08_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt




#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=24:00:00
#SBATCH --job-name scan_chrom07
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom07_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr07_{}.txt -o ceratodon_scan_DAF_Chr07_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt






python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01_28502066.txt -o ceratodon_scan_DAF_Chr01_28502066.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal

python3 ../splitfile.py ceratodon_input_DAF_Chr11.txt 11 8674 16655102 > chrom11_list.txt

python3 splitfile.py ceratodon_input_DAF_Chr12.txt 12 2095 16452710 > chrom12_list.txt


i=01
start=2066
end=28999744

python3 ../splitfile.py ceratodon_input_DAF_Chr${i}.txt ${i} ${start} ${end} > chrom${i}_list.txt


i=02
start=14391
end=26628310

i=03
start=491
end=25156131

i=04
start=18005
end=22768693

i=05
start=1534
end=19968821

i=06 
start=1784
end=18973055

i=07
start=4198
end=17960807

i=08
start=1175
end=17565879

i=09
start=837
end=17519721

i=10
start=5310
end=17229241

# 10 11


# prep the ceratodon inout files
for i in {1..9}
do 
cd /ohta2/meng.yuan/ceratodon/ballermix/chroms
mkdir chrom0${i}
cd chrom0${i}
ln -s /ohta2/meng.yuan/ceratodon/ballermix/ceratodon_input_DAF_Chr0${i}.txt ./
done

for i in {1..9}
do 
echo ${i}
head -n 2 ceratodon_input_DAF_Chr0${i}.txt
tail -n 1 ceratodon_input_DAF_Chr0${i}.txt
done


python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr12_1002095.txt -o ceratodon_scan_DAF_Chr12_1002095.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal



parallel --jobs 10 python3 ${app}/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt -o rumex_scan_DAF_Jun13.txt --spect rumex_spect_DAF_May9.txt --findBal

find *.fastq | parallel "fastqc -outdir fastqc_before/ {}" 


 1223  grep 'LG1' rumex_input_DAF_May9_withLG.txt>rumex_input_DAF_May9_LG1.txt
 1224  grep 'LG2' rumex_input_DAF_May9_withLG.txt>rumex_input_DAF_May9_LG2.txt
 1225  grep 'LG3' rumex_input_DAF_May9_withLG.txt>rumex_input_DAF_May9_LG3.txt
 1226  grep 'LG4' rumex_input_DAF_May9_withLG.txt>rumex_input_DAF_May9_LG4.txt


 1229  for i in {1..5}; do cut -f 2,3,4,5 rumex_input_DAF_May9_LG${i}.txt > output/rumex_input_DAF_Jul6_LG${i}.txt; done




