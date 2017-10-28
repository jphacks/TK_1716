#!/usr/bin/env python
# vim:fileencoding=utf-8

import time
import numpy as np
import pyaudio as pa
import requests
import sys
import json
import string, random

# check sound recording device
def check_sound_device():
    # pyaudio
    p_in = pa.PyAudio()
    bytes = 2
    py_format = p_in.get_format_from_width(bytes)
    fs = 0
    channels = 1
    use_device_index = -1
    
    # find input device
    print()
    print("device num: {0}".format(p_in.get_device_count()))
    print()
    for i in range(p_in.get_device_count()):
        maxInputChannels = p_in.get_device_info_by_index(i)['maxInputChannels']
        if maxInputChannels > 0:
            print('### Found!: index = %d, maxInputChannels = %d' % (i, maxInputChannels))
            print(p_in.get_device_info_by_index(i))
            print()
            if use_device_index == -1:
                use_device_index = i
                fs = int(p_in.get_device_info_by_index(i)['defaultSampleRate'])
        else:
            print(p_in.get_device_info_by_index(i))
            print()

    chank_size = fs * 1

    if use_device_index == -1:
        print("\nError! Can't find any usuable sound input device.")
        print("  Check your environment or try other computer.")
    else:
        print("\nYour environment is OK.")
        print('  use_device_index = ', use_device_index)
        print('  SampleRate = ', fs)

    return
    
if __name__ == "__main__":
    global chunk
    
    in_stream = check_sound_device()

