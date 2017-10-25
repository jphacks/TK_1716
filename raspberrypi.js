var Gpio = require('onoff').Gpio
var led = new Gpio(17, 'out');

var bleno = require('bleno');
var util = require('util');

var Characteristic = bleno.Characteristic;
var PrimaryService = bleno.PrimaryService;

//Advertising開始（プロファイル開始、一番上の階層）、FF10
bleno.on('stateChange', function(state) {
        if(state=='poweredOn') {
                console.log('bluetooth power on')
                bleno.startAdvertising('led service', ['FF10']);
        }
});

//サービス設定、二番目の階層、ff10
bleno.on('advertisingStart', function(err) {
        if(!err) {
                console.log('start advertise')
                bleno.setServices([lightService]);
        }
});

//Characteristic設定、三番目の階層、ff11、最後の行で代入している感じ
var SwitchCharacteristic = function() {
        SwitchCharacteristic.super_.call(this, {
                uuid: 'ff11',
                properties: ['read', 'write']
        });

};
util.inherits(SwitchCharacteristic, Characteristic);

//Characteristicが読まれたらどうするか
SwitchCharacteristic.prototype.onReadRequest = function(offset, callback) {
        console.log('read request');
        var data = new Buffer(1);
        data[0] = led.readSync();
        callback(this.RESULT_SUCCESS, data);
};

//Characteristicが書き込まれたらどうするか、led.writeSyncでledに対して書き込みをしている。
SwitchCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
        console.log('write request: ' + data.toString('hex'));
        led.writeSync(data[0]);
        callback(this.RESULT_SUCCESS);
};

//サービスを設定している。これが上の方に入ってくる
var lightService = new PrimaryService({
    uuid: 'ff10',
    characteristics: [
        new SwitchCharacteristic()
    ]
});

//終了時の設定
function exit() {
        led.unexport();
        process.exit();
}
process.on('SIGINT', exit); //ctr + c などの信号