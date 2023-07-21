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



--wd $PWD




