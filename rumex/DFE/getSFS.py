import sys
import re
import pandas as pd
# usage: python3 getSFS.py XX.vcf
# output is XX.vcf.SFS

f_in = open(sys.argv[1], "r")
# add another option for 0 fold or 4 fold sites
out_file = sys.argv[1] + ".SFS"
f_out = open(out_file, "w")
list_alt = []
list_minor = []

content = f_in.readlines()
for line in content:
    if re.match('^#(.*)', line):  # skip header
        continue
    vcf_line = line.split()
    cnt_alt = 0
    cnt_minor = 0
    for i in range(9, 29):  # for the individuals
        if vcf_line[i][0:3] == '0/0' or vcf_line[i][0:3] == './.':
            continue
        if vcf_line[i][0:3] == '0/1':
            cnt_alt += 1
        if vcf_line[i][0:3] == '1/1':
            cnt_alt += 2
    list_alt.append(cnt_alt)  # derived allele count
    if cnt_alt <= 20:
        cnt_minor = cnt_alt
    else:
        cnt_minor = 40 - cnt_alt
    list_minor.append(cnt_minor)


# print(list_alt, file=f_out)
# print unfolded (derived allele) SFS
print("unfolded SFS", file=f_out)
pd_alt = pd.DataFrame(list_alt, columns=['count'])
counts = pd_alt["count"].value_counts().sort_index()
print(counts, file=f_out)
list_cnts = counts.tolist()
for i in range(len(list_cnts)):
    list_cnts[i] = str(list_cnts[i])
print(' '.join(list_cnts), file=f_out)

print("\n", file=f_out)

# print folded (minor allele) SFS
# print(list_minor, file=f_out)
print("folded SFS", file=f_out)
pd_minor = pd.DataFrame(list_minor, columns=['count'])
counts = pd_minor["count"].value_counts().sort_index()
print(counts, file=f_out)
list_cnts = counts.tolist()
for i in range(len(list_cnts)):
    list_cnts[i] = str(list_cnts[i])
print(' '.join(list_cnts), file=f_out)


f_in.close()
f_out.close()
