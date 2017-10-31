# Arduinoでの実装

## 概要
温度センサ、湿度センサ、臭気センサの値を取得し、シリアル通信を介してRaspberry Piに送信する。温度センサは分解能が0.0625℃であるため、実際の温度を0.0625で割った整数で、湿度センサはそのままの整数、臭気センサは閾値を設けて0か1で送信する。

## 詳細内容
* [においセンサ TGS2450](http://akizukidenshi.com/catalog/g/gP-00989/)
周囲の悪臭（メチルメルカプタン、硫化水素などの硫黄化合物系ガス；うんちの匂いにもこれらは含まれる）に反応して抵抗値が変わるセンサ。抵抗を直列に挟んで分圧して電圧値を読んだ。ヒーターがあるのだが、所定のデューティー比以下で動作させないと焼き切れる恐れがある。
* [温湿度センサ DHT11](http://akizukidenshi.com/catalog/g/gM-07003/)
温度および湿度を1-Wireで送信するモジュール。精度±2℃となっており分解能はあまり良くない
* [温度センサ ADT7410](http://akizukidenshi.com/catalog/g/gM-06675/)
温度をI2Cで通信するモジュール。温度の分解能が高かったため追加で用いた。

## 今後の課題
これらのセンサ取得をRaspberry Piで行いたい。

## Requirements
* [Adafruit_Sensor.h](https://github.com/adafruit/Adafruit_Sensor)
* [DHT.h](https://github.com/adafruit/DHT-sensor-library)
* [skADT7410.h](http://www.geocities.jp/zattouka/GarageHouse/)