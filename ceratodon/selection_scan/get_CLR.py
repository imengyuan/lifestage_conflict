import pandas as pd

# read scan
data1 = "/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/" \
        "Manuscripts/ceratodon_haploid_sel/balsel/"
file_path1 = data1 + "balsel_scanc95.txt"
scanc95 = pd.read_table(file_path1, header=0)

# read gff
data2 = "/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/" \
        "Manuscripts/ceratodon_haploid_sel/deseq2/"
file_path2 = data2 + "R40_GG1U_combined.gene.final.gff"
gff = pd.read_table(file_path2, header=None)
gff.columns = ["chrom", "start", "end", "gene"]


window_size = 7000
num_windows = len(scanc95) // window_size

results = []
for i in range(1, num_windows + 1):
    start = (i - 1) * window_size
    end = i * window_size
    window_df = scanc95.iloc[start:end]
    result = pd.merge(window_df, gff, on='chrom')
    result = result[(result['physPos'] >= start) & (result['physPos'] <= end)]
    results.append(result)

final_result = pd.concat(results)


output_file = '/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/' \
              'Manuscripts/ceratodon_haploid_sel/balsel/balsel_sites.txt'
final_result.to_csv(output_file, sep='\t', index=False)
