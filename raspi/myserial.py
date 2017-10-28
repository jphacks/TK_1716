# -*- coding: utf-8 -*-
import serial
ser = serial.Serial('/dev/ttyACM0', 9600)
#ser = serial.Serial('/dev/cu.usbmodem1421', 9600)
while True:
    read_serial = ser.readline()
    #read_serial = '380,40,0,0,0'
    print read_serial
    f = open('text.txt', 'w') # 書き込みモードで開く
    f.write(read_serial) # 引数の文字列をファイルに書き込む
    f.close() # ファイルを閉じる
    #print 'a'
