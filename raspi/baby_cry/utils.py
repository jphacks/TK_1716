# -*- coding:utf-8 -*-

import numpy as np
import os


def import_wav_data_in_dir(datapath):
    '''
    datapathで指定したディレクトリ内のwav fileを全て取得
    return : [file, file, ...]
    '''
    files = []
    for x in os.listdir(datapath):
        if '.wav' in x:
            files.append(x)
    return files


def smoothing_fft(abs_cry_array):
    '''
    fftによる平滑化
    abs_cry_array : 音声vectorの絶対値
    '''
    N = len(abs_cry_array)
    fc = 0.001
    
    F = np.fft.fft(abs_cry_array)/(N/2)
    
    freq = np.fft.fftfreq(len(abs_cry_array))
    
    F[0] = F[0]/2
    
    F[(freq > fc)] = 0
    F[(freq < 0)] = 0
    
    f2 = np.fft.ifft(F)*(2*N/2)
    
    return f2


def smoothing_ave(abs_cry_array, width=100):
    '''
    averageによる平滑化
    abs_cry_array : 音声vectorの絶対値
    '''
    # array_sizeはwidth分小さくなる
    smoothed_array = []
    for i in range((width / 2),len(abs_cry_array) - (width/2)):
        smoothed_array.append(np.mean(abs_cry_array[i - (width/2):i + (width/2) + 1]))
    return np.array(smoothed_array)


def devide_cry_by_value(cry_array):
    '''
    音声ベクトルを分割
    babyが泣いているところのみを分割、抽出
    cry_array : voice vector
    return : list([cry, cry, ...])
    '''
    # cry_arrayの絶対値をとって平滑化
    width=100
    bottom_limit = 0.01
    standard_order = 300
    magni = 2
    length_limit = 2048
    
    smoothed_abs_cry_array = smoothing_fft(smoothing_ave(np.abs(cry_array), width))
    # bottom_limit以上で下からstandard_order番目の値を静音の基準に
    standard = smoothed_abs_cry_array[smoothed_abs_cry_array > bottom_limit].copy()
    standard.sort()
    standard = standard[standard_order]
    standard = standard * magni
    
    index_array = np.where(smoothed_abs_cry_array > standard)[0]
    
    if len(index_array) < 1:
        return None
    
    # width分修正
    index_array = index_array + (width / 2)
    # index_arrayを、塊ごとに分割
    devided_cry_array = []
    start = index_array[0]
    end = index_array[0]
    
    for ix in index_array[1:]:
        if ix == end + 1:
            end = ix
        else:
            cry_block = cry_array[start:end]
            if len(cry_block) > length_limit:
                devided_cry_array.append(cry_block)
            start = ix
            end = ix
    return devided_cry_array

