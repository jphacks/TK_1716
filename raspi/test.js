var serialport = require('serialport');

var portName = "/dev/ttyACM0";
var sp = new serialport.SerialPort(portName, {
	baudRate: 115200,
	dataBits: 8,
	parity: 'none',
	stopBits: 1,
	flowControl: false//,
//	parser: serialport.parsers.readline("\n")
});
