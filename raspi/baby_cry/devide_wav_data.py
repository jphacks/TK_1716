# -*- coding:utf-8 -*-

import soundfile as sf

from utils import devide_cry_by_value, import_wav_data_in_dir


# import wav data
datapath = 'cry_data/wav_data/'
files = import_wav_data_in_dir(datapath)

# devide wav data and save
for f in files:
    x, sample_rate = sf.read(datapath + f)
    devided_cry_array = devide_cry_by_value(x)
    if devided_cry_array is None:
        continue
    for i in range(len(devided_cry_array)):
        sf.write('cry_data/devided_wav_data/' + str(i) + '-' + f, devided_cry_array[i], sample_rate)
