# count total number of alleles, alt alleles, ref alleles, minor alleles
# out put chrom, pos, ref allele, cnt_ref, cnt_alt, cnt_minor, cnt_allele

import sys

input_file = sys.argv[1]
output_file = input_file + ".allele.cnt"
header = ["chrom", "physPos", "ref", "alt", "cnt_minor", "cnt_alt", "cnt_ref", "n"]

with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    print("\t".join(header), file=f_out)
    for line in f_in:
        if line.startswith("#"):  # skip header
            continue
        vcf_line = line.split()
        cnt_alt = 0
        cnt_minor = 0
        result_list = [vcf_line[0], vcf_line[1], vcf_line[3], vcf_line[4]]
        cnt_missing = 0
        cnt_allele = 0
        cnt_ref = 0
        # result_list.append(vcf_line[0], vcf_line[1])
        for i in range(9, 29):  # for the individuals
            if vcf_line[i][0:3] == './.':
                cnt_missing += 1
                continue
            if vcf_line[i][0:3] == '0/0':
                cnt_ref += 2
            if vcf_line[i][0:3] == '0/1':
                cnt_alt += 1
                cnt_ref += 1
            elif vcf_line[i][0:3] == '1/1':
                cnt_alt += 2
        # list_alt.append(cnt_alt)  # derived allele count
        cnt_minor = cnt_alt if cnt_alt <= 20 else 40 - cnt_alt
        # list_minor.append(cnt_minor)
        cnt_allele = 40 - 2 * cnt_missing
        # cnt_ref = 40 - 2 * cnt_missing - cnt_alt
        result_list.extend([str(cnt_minor),str(cnt_alt),str(cnt_ref), str(cnt_allele)])
        output_line = "\t".join(result_list) + "\n"
        f_out.write(output_line)

