import serial
ser = serial.Serial('/dev/ttyACM0', 115200)
s = [0,1]
while True:
    read_serial = ser.readline()
    s[0] = str(int (ser.readline(), 16))
    print s[0]
    print read_serial
    
f = open('text.txt', 'w') # 書き込みモードで開く
f.write(str) # 引数の文字列をファイルに書き込む
f.close() # ファイルを閉じる
