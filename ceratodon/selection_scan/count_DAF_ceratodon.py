import sys

# future version all derive allele count, compare ref allele to out group
# count minor alleles from 16 haploid samples

input_file = sys.argv[1]
output_file = input_file + ".allele.cnt"
header = ["chrom", "physPos", "ref", "alt", "outgroup", "cnt_minor", "cnt_alt", "cnt_ref", "n"]

with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    print("\t".join(header), file=f_out)
    for line in f_in:
        if line.startswith("#"):  # skip header
            continue
        vcf_line = line.split()
        result_list = [vcf_line[0], vcf_line[1], vcf_line[3], vcf_line[4]]
        # get outgroup allele from chile samples
        outgroup1 = vcf_line[25][0]
        outgroup2 = vcf_line[26][0]

        if outgroup1 == outgroup2:
            if outgroup1 == '0':
                outgroup = 0
            elif outgroup1 == '1':
                outgroup = 1
            else:
                continue
        else:
            if outgroup1 != "." and outgroup2 != ".":
                continue
            else:
                outgroup = outgroup1 if outgroup1 != '.' else outgroup2

        cnt_minor = 0
        cnt_missing = 0
        cnt_allele = 0
        cnt_ref = 0
        cnt_alt = 0
        cnt_derived = 0

        # counts alleles with the following list comprehension:
        genotypes = vcf_line[9:25]
        cnt_ref = sum([1 for genotype in genotypes if genotype[0] == '0'])
        cnt_alt = sum([1 for genotype in genotypes if genotype[0] == '1'])
        cnt_missing = sum([1 for genotype in genotypes if genotype[0] == '.'])

        cnt_minor = cnt_alt if cnt_alt <= 8 else 16 - cnt_alt
        cnt_allele = 16 - cnt_missing
        cnt_derived = cnt_alt if vcf_line[3] == outgroup else cnt_ref

        result_list.extend([str(outgroup), str(cnt_minor), str(cnt_alt), str(cnt_ref), str(cnt_allele)])
        output_line = "\t".join(result_list) + "\n"
        f_out.write(output_line)

