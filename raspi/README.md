# Raspberry Piでの実装
## 実行
sh run_raspi.sh

## 概要
raspberry pi がハードウェアの中心として機能し、データ収集・iOSアプリとの通信を行う。
赤ちゃんの泣き声を検知し、判別するプログラムと、Arduinoで得られたセンサデータががシリアル通信で送られてくるため、それを読み込むプログラムと、全体のデータをBluetoothで送信するプログラムに分けられる。

## 詳細内容
- myserial.py Arduinoからのシリアル通信データを受信し、ファイルに書き込むもの
- baby_cry 赤ちゃんの泣き声検知[[詳細](https://github.com/jphacks/TK_1716/blob/master/raspi/baby_cry/README.md)]
- main.js 各プログラムから送られてくるデータを読み込み、ブルートゥースで送信するもの

## 今後の課題
今回用いたセンサにアナログ出力のものがあったのでArduinoを使う必要があったが、センサの値の取得もRaspberry Pi+ADコンバーターとしてコンパクトにしたい。

## Requirement
Python==2.7.13 
Node.js==6.11.5
[Bleno](https://github.com/sandeepmistry/bleno)
