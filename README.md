# あのね、

<a href="https://www.youtube.com/watch?v=9jZZrYWHrus&feature=youtu.be"><img src="https://github.com/jphacks/TK_1716/blob/master/img/thumbnail.png" width="700px"></a>

## 製品概要
### Baby x Tech

### 背景（製品開発のきっかけ、課題等）

今回のハッカソンに向けて身近な問題点について考えていたところ、メンバーの一人に最近姪が生まれたのだが、赤ちゃんは子育てが大変だという話になった。また、別のメンバーは年の離れた妹がおり、親が子育てをしている姿を間近で見ていたので、赤ちゃんを育てるのが大変だという問題に取り組みたいと思った。


そこで最近子供が生まれた親にヒアリングをしたところ以下のような問題点があることがわかった。

赤ちゃんとお出かけするとき、お母さんが常に赤ちゃんの様子を見続けることは難しい。例えばベビーカーは地面からの放射受ける上、幌が温室のような役割を果たすので知らぬうちに高温になってしまう。また、赤ちゃんの仕草や泣き声からは排泄をしたかどうか、空腹なのかといったことがわかりづらい。

まとめると。

* 赤ちゃんがベビーカーの中でどんな温度を感じているかがわからない。
* 赤ちゃんがうんちしたのかオシッコしたのかがわからない。
* 赤ちゃんの泣き声が何を伝えているのかがわからない。

赤ちゃんとの外出時には上記以外にも、

* おむつを替えたい時、オッパイをあげたいとき、授乳室やおむつ台の場所がすぐに分からない

という問題がある。

そこで私たちは外出時でも赤ちゃんの状態を常に把握できるウェアラブルデバイスを開発することにした。  

具体的には、

* 赤ちゃんの温度、湿度状態
* うんちが出たかどうか
* 泣き声とそれの意味すること

を把握するウェアラブルデバイスを作成し、

* そのデータをリアルタイムでモニターし
* 赤ちゃんの異常を検知した時に近くの授乳室やおむつ台を案内する

アプリを作成した。

このデバイスが育児のストレスを解消し、赤ちゃんを育てやすい環境の構築の一助になれば幸いです。


### 製品説明（具体的な製品の説明）
ウェアラブル端末を赤ちゃんのおむつに付けると、お母さんはアプリで赤ちゃんの様子を管理することができる。使用例を以下の図に示す。  
<img src="https://github.com/jphacks/TK_1716/blob/master/img/usecase.png" width="750px">

### 特長

#### 1. 体温、湿度検知
赤ちゃんの体温や湿度をセンサが検知しアプリ上に表示してくれる。閾値を越えるとアラートで通知してくれる。

#### 2. うんち排出検知

赤ちゃんがうんちをすると臭気センサがそれを検知し、アプリで通知。またGPSの情報から近くのおむつ台の位置を教えてくれる。

#### 3. 泣き声検知
赤ちゃんの泣き声を音声センサが検知し、機械学習を用いて「空腹」「怒り」「不快」の3クラスに分類。赤ちゃんの状態をアプリに通知し、「空腹」の際はGPSの情報から近くの授乳室の場所を教えてくれる。

#### 4. 道案内
上記の通り、赤ちゃんの状態に異常が生じると現在地の近くにある授乳室やおむつ台への経路を表示する。

#### 5. ウェアラブル端末とのBluetooth通信
本製品は外出時の利用も想定しているため、wifi環境下でなくても利用できるようウェアラブル端末とiOSとの通信をBluetoothで行った。


### 解決出来ること
ウェアラブルデバイスにより赤ちゃんの状態を常に監視することができるため、外出時にお母さんが赤ちゃんの様子をみることの助けになる。さらに、赤ちゃんとのコミュニケーションがより円滑にできるようになるため、赤ちゃんにとって不快な状態にすぐに対処することができるようになる。したがって、赤ちゃんと外出するときの心理的ハードルが下がり、純粋に二人でのお出かけを楽しむことができる。

このデバイスは外出時以外の問題にも対処することができる。例えば、家事で忙しくて赤ちゃんから目を離さなければならないときにも、赤ちゃんの状態を監視・通知してくれる。なのでお母さんもあんしん。赤ちゃんにとっても快適。

### 今後の展望

* ハードウェアの作成
今回のプロダクトは機能の実装に重点を置いた。
赤ちゃんが身につけるデバイスであるため、赤ちゃんの生活を邪魔せずかつ怪我や誤飲の可能性がない形状にしなければならない。

* 育成日記機能の作成
取得した赤ちゃんの体温やうんちの検知結果をDBに保存し、日々の体調管理に役立てる。

* 母子手帳機能の作成
予防接種情報など育児に関して記録すべき事項を全てこのアプリで管理する。

## 開発内容・開発技術
<img src="https://github.com/jphacks/TK_1716/blob/master/img/system.png" width="600px">

### 活用した技術
#### API・データ
* [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/?hl=ja)
* [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/?hl=ja)
* [NEC Sound Event Recognition API](https://www6.arche.blue/portal/)

#### フレームワーク・ライブラリ・モジュール
* [swift](https://swift.org/)
* [python](https://www.python.jp/)
	- [Numpy](http://www.numpy.org/)
	- [Scipy](https://www.scipy.org/)
	- [pandas](http://pandas.pydata.org/)
	- [scikit-learn](http://scikit-learn.org/)
	- [PyAudio](https://people.csail.mit.edu/hubert/pyaudio/)
	- [Scikits.Talkbox](https://github.com/cournape/talkbox)
    - [Bottle](https://bottlepy.org/docs/dev/)
	- [Jinja2](http://jinja.pocoo.org/docs/2.9/)
	- [mod_wsgi](https://github.com/GrahamDumpleton/mod_wsgi)
* [MySQL](https://www.mysql.com/jp/)
* [Node.js](https://nodejs.org/ja/)
	- [bleno](https://github.com/sandeepmistry/bleno)
* [においセンサ TGS2450](http://akizukidenshi.com/catalog/g/gP-00989/)
* [温湿度センサ DHT11](http://akizukidenshi.com/catalog/g/gM-07003/)
* [温度センサ ADT7410](http://akizukidenshi.com/catalog/g/gM-06675/)

#### デバイス
* [AWS EC2/ubuntu](https://aws.amazon.com/jp/ec2/)
* [Raspberry Pi](https://www.raspberrypi.org/)
* [Arduino](https://www.arduino.cc/)

### 研究内容・事前開発プロダクト
#### 事前開発プロダクト
* 赤ちゃん音声のデータ収集
* スクレイピングによる授乳室、おむつ台の取得
* Raspberry Pi、iOS間のbluetooth通信

### 独自開発技術（Hack Dayで開発したもの）
#### 2日間に開発した独自の機能・技術
* [赤ちゃん音声の分類モデル作成](https://github.com/jphacks/TK_1716/blob/master/raspi/baby_cry/README.md)
* 各種センサ情報の取得、整形および通信
* iOSアプリケーションのインターフェース作成、画面遷移
