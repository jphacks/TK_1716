https://qiita.com/kentarohorie/items/b9549af9c71886860866

var Gpio = require('onoff').Gpio
var led = new Gpio(17, 'out');


//var serialPort = require("serialport")
//var sp = new serialPort.SerialPort("/dev/ttyACM0",{
//	baudrate: 115200,
//	parser:serialPort.parsers.readline("\n")
//});

var i2c = require('i2c');
var adt7410_address = 0x48;
var adt7410 = new i2c(adt7410_address, {device: '/dev/i2c-1'});

function readTemp(){
  var data0 = adt7410.readBytes(0x00, 2, function(err, data) {
    var temp, value;
    temp = (data[0] << 8 | data[1]) >> 3;
    if (temp >= 4096) {
      temp -= 8192;
    }
    value = temp * 0.0625;
    console.log("Temperature: " + value + " [Deg. C.]");
    //callback(value);
  });
  var temp0 = (data0[0] << 8 | data0[1]) >> 3;
    if (temp0 >= 4096) {
      temp0 -= 8192;
    }

  //var value0 = temp0 * 0.0625

  value0 = new Buffer(2);
  //value0.writeUInt16BE(temp0);
  value0.writeUInt16BE(500);

  return value0;
};

console.log(readTemp());

var bleno = require('bleno');
var util = require('util');

var Characteristic = bleno.Characteristic;
var PrimaryService = bleno.PrimaryService;

bleno.on('stateChange', function(state) {
        if(state=='poweredOn') {
                console.log('bluetooth power on')
                bleno.startAdvertising('raspberrypi', ['FF10']);
        }
});

bleno.on('advertisingStart', function(err) {
        if(!err) {
                console.log('start advertise')
                bleno.setServices([lightService]);
        }
});

var TempCharacteristic = function() { //heater
        TempCharacteristic.super_.call(this, {
                uuid: 'ff11',
                properties: ['read', 'write']
        });

};
util.inherits(TempCharacteristic, Characteristic);


var HumidityCharacteristic = function() { //heater
        HumidityCharacteristic.super_.call(this, {
                uuid: 'ff12',
                properties: ['read', 'write']
        });

};
util.inherits(HumidityCharacteristic, Characteristic);

var SmellCharacteristic = function() { //heater
        SmellCharacteristic.super_.call(this, {
                uuid: 'ff13',
                properties: ['read', 'write']
        });

};
util.inherits(SmellCharacteristic, Characteristic);

var CryCharacteristic = function() { //heater
        CryCharacteristic.super_.call(this, {
                uuid: 'ff14',
                properties: ['read', 'write']
        });

};
util.inherits(CryCharacteristic, Characteristic);

var DownCharacteristic = function() { //heater
        DownCharacteristic.super_.call(this, {
                uuid: 'ff15',
                properties: ['read', 'write']
        });

};
util.inherits(DownCharacteristic, Characteristic);

TempCharacteristic.prototype.onReadRequest = function(offset, callback) {
        console.log('read request heat');
        var data = new Buffer(readTemp());
	console.log(data);
        callback(this.RESULT_SUCCESS, data);
};

TempCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
        console.log('write request: ' + data.toString('hex'));
        led.writeSync(data[0]);
        callback(this.RESULT_SUCCESS);
};


HumidityCharacteristic.prototype.onReadRequest = function(offset, callback) {
        console.log('read request humidity');
        var data = new Buffer(readTemp());
	data[0] = 12;
	console.log(data);
        callback(this.RESULT_SUCCESS, data);
};


SmellCharacteristic.prototype.onReadRequest = function(offset, callback) {
        console.log('read request smell');
        var data = new Buffer(readTemp());
	console.log(data);
        callback(this.RESULT_SUCCESS, data);
};


CryCharacteristic.prototype.onReadRequest = function(offset, callback) {
        console.log('read request cry');
        var data = new Buffer(readTemp());
	console.log(data);
        callback(this.RESULT_SUCCESS, data);
};


DownCharacteristic.prototype.onReadRequest = function(offset, callback) {
        console.log('read request heat');
        var data = new Buffer(readTemp());
	console.log(data);
        callback(this.RESULT_SUCCESS, data);
};



var lightService = new PrimaryService({
    uuid: 'ff10',
    characteristics: [
        new TempCharacteristic(),
	new HumidityCharacteristic(),
	new SmellCharacteristic(),
	new CryCharacteristic(),
	new DownCharacteristic()
    ]
});

function exit() {
        led.unexport();
        process.exit();
}
process.on('SIGINT', exit); //ctr + c などの信号

