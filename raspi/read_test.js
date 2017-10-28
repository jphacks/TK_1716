
const fs = require('fs');

fs.readFile('/Users/tomoyukiyyamasaki/github/TK_1716/raspi/text.txt', (err, data) => {
  if (err) throw err;
  console.log(data);
});


// カンマで分割し配列に格納
var resArray = data.split(",");
// それぞれに番号を付加
var ret = "";
for( var i=0 ; i<resArray.length ; i++ ) {
   ret += '[' + (i+1) + '] ' + resArray[i] + "\n";
}
// 表示
console.log(ret);
