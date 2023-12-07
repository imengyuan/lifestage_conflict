# test using one node and parallelize using multiple cpus at a time
# then add more nodes

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=0:30:00
#SBATCH --job-name rumex_scan
module load python
module load NiaEnv/2019b gnu-parallel
app=/scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus-main

cd /scratch/w/wrighste/yuanmeng/rumex/ballermix
parallel --jobs 10 python ${app}/BalLeRMix+_v1.py -i rumex_input_DAF_May9.txt -o rumex_scan_DAF_Jun13.txt --spect rumex_spect_DAF_May9.txt --findBal

# no running.. why?
# just get it running


--wd $PWD


# write splitfile.py for ceratodon
# get it running and some updates for stephen

#ceratodon_input_DAF.txt

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=18:00:00
#SBATCH --job-name scan_chrom01_1
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom01_list1.txt | parallel -j 20 --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01_{}.txt -o ceratodon_scan_DAF_Chr01_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt 


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=20:00:00
#SBATCH --job-name scan_chrom01_2
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom01_list2.txt | parallel -j 20 --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01_{}.txt -o ceratodon_scan_DAF_Chr01_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out2.txt 


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=20:00:00
#SBATCH --job-name scan_chrom01_3
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom01_list3.txt | parallel -j 18 --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01_{}.txt -o ceratodon_scan_DAF_Chr01_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out3.txt 


# keep submitting jobs
# dont specify number of jobs, cpu usage will be higher



# chrom11 16008674 16508674



# chrom07
8004198 7504198 10504198 17504198


#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=12:00:00
#SBATCH --job-name scan_chrom07
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom07_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i /scratch/w/wrighste/yuanmeng/ceratodon/chroms/chrom07/ceratodon_input_DAF_Chr07_{}.txt -o /scratch/w/wrighste/yuanmeng/ceratodon/chroms/chrom07/ceratodon_scan_DAF_Chr07_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt


ceratodon_input_DAF_Chr07_12504198.txt

-rw-r----- 1 yuanmeng wrighste 814798 Nov 27 15:05 ceratodon_scan_DAF_Chr08_1001175.txt
-rw-r----- 1 yuanmeng wrighste 551746 Nov 27 10:28 ceratodon_scan_DAF_Chr08_17001175.txt
-rw-r----- 1 yuanmeng wrighste 285528 Nov 27 03:11 ceratodon_scan_DAF_Chr08_501175.txt
-rw-r----- 1 yuanmeng wrighste 180356 Nov 27 00:52 ceratodon_scan_DAF_Chr08_1175.txt
-rw-r----- 1 yuanmeng wrighste   7796 Nov 26 23:40 ceratodon_scan_DAF_Chr08_17501175.txt

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --time=10:00:00
#SBATCH --job-name scan_chrom08
module load python
module load NiaEnv/2019b gnu-parallel

source /scratch/w/wrighste/yuanmeng/bin/activate
pip install --no-index --upgrade pip
pip install numpy --no-index

cat chrom08_list.txt | parallel --joblog runtask.log --resume 'python /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/BallerMixPlus/BalLeRMix+_v1.py -i /scratch/w/wrighste/yuanmeng/ceratodon/chroms/chrom08/ceratodon_input_DAF_Chr08_{}.txt -o /scratch/w/wrighste/yuanmeng/ceratodon/chroms/chrom08/ceratodon_scan_DAF_Chr08_{}.txt --spect /scratch/w/wrighste/yuanmeng/ceratodon/ballermix/ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt





# chrom 12, 02 done

cat chrom12_list.txt | parallel -j 10 'python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr12_{}.txt -o ceratodon_scan_DAF_Chr12_{}.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt

cat chrom02_list.txt | parallel -j 20 'python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr02_{}.txt -o ceratodon_scan_DAF_Chr02_{}.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt


# chrom01
cat chrom01_list.txt | parallel -j 20 'python3 /ohta2/meng.yuan/apps/BallerMixPlus/BalLeRMix+_v1.py -i ceratodon_input_DAF_Chr01_{}.txt -o ceratodon_scan_DAF_Chr01_{}.txt --spect ceratodon_spect_DAF.txt --usePhysPos --rec 0.000001 --findBal' > out.txt













