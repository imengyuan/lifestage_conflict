

sample=g_specific.U
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt bootstrap_UV/${sample}.nonsyn.sfs_${i}.txt bootstrap_UV/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts.txt


for sample in "g_specific.V" "g_specific.U" "s_specific.V" "s_specific.U"

sample=s_specific.V
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt bootstrap_UV/${sample}.nonsyn.sfs_${i}.txt bootstrap_UV/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts.txt


sample=s_specific.U
for i in {1..200}; do
# generate sfs.txt for input
cd /ohta2/meng.yuan/ceratodon/VCF_genes/
cat head.txt bootstrap_UV/${sample}.nonsyn.sfs_${i}.txt bootstrap_UV/${sample}.syn.sfs_${i}.txt>/ohta2/meng.yuan/ceratodon/dfe_a/sfs_expressed_test.txt
# run est_dfe
cd /ohta2/meng.yuan/ceratodon/dfe_a
est_dfe -c est_dfe_configfile_neut.txt
est_dfe -c est_dfe_configfile_sel.txt
prop_muts_in_s_ranges -c results_dir_sel/est_dfe.out 
cut  -d' ' -f 3,6,9,12 prop_muts_in_s_ranges.out>output/${sample}.prop_muts_${i}.txt
done
cat output/${sample}.prop_muts_*.txt>${sample}.prop_muts.txt


