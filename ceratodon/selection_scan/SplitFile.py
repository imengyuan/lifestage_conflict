#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import pandas as pd
import numpy as np
import sys

data = pd.read_csv(sys.argv[1], sep="\t", header=0)

window_length = 1000000
step_length = 500000
chr_num = sys.argv[2]
start_point = int(sys.argv[3])
end_point = int(sys.argv[4])
header = ['physPos', 'genPos', 'x', 'n']
header = pd.DataFrame(header)


for i in np.arange(start_point, end_point, step_length):
    header.to_csv('ceratodon_input_DAF_Chr' + chr_num + "_" + str(i) + '.txt', sep='\t')
    data_new = data[(data["physPos"] >= i) & (data["physPos"] <= i + window_length)]
    data_new.to_csv('ceratodon_input_DAF_Chr' + chr_num + "_" + str(i) + '.txt', sep='\t', index=False)
    print(i)
