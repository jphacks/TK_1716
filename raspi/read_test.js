
const fs = require('fs');

function readText(filename){
  text = fs.readFileSync(filename, 'utf8');
  text = text.replace(/\r?\n/g,””);
 text = text.split(“,”);
 text = text.map(function(n) { return Number(n)});
 return text //array of int-s
}
