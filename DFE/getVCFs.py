# get syn and nonsyn VCFs from a big VCF and the sitType output
# can be used to run pixy to get syn/nonsyn pi values
# usage: python getVCFs.py test.vcf test.siteTypes
import sys
import re

f_in1 = open(sys.argv[1], "r")  # vcf file
f_in2 = open(sys.argv[2], "r")  # site type file

out_file1 = sys.argv[1][:-3] + "syn.vcf"
out_file2 = sys.argv[1][:-3] + "nonsyn.vcf"

f_out1 = open(out_file1, "w")
f_out2 = open(out_file2, "w")
list_nonsyn = []
list_syn = []

# read siteType file into lists
content = f_in2.readlines()
for line in content:
    site_line = line.split()
    degeneracy = site_line[4]
    if degeneracy == "0":  # nonsyn sites
        list_nonsyn.append(site_line[0:2])  # both are strings
    elif degeneracy == "4":  # syn sites
        list_syn.append(site_line[0:2])
# print(syn_list)
# print(nonsyn_list)


# read and parse VCF file
content = f_in1.readlines()
for line in content:
    if re.match('^#(.*)', line):  # header
        # print header as it is in the output vcfs
        print(line.strip(), file=f_out1)
        print(line.strip(), file=f_out2)
        continue
    vcf_line = line.split()
    chrom = vcf_line[0]
    pos = vcf_line[1]
    if chrom[0:2] != 'LG':  # skip non LG scaffolds
        continue

    if [chrom, pos] in list_syn:
        print(line.strip(), file=f_out1)

    if [chrom, pos] in list_nonsyn:
        print(line.strip(), file=f_out2)

f_in1.close()
f_in2.close()
f_out1.close()
f_out2.close()

