#!/bin/sh

python /home/pi/test/TK_1716/raspi/baby_cry/sd_client.py &
sudo node /home/pi/test/TK_1716/raspi/main.js &
python /home/pi/test/TK_1716/raspi/myserial.py
