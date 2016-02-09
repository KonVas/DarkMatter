var http = require('http');

var osc = require('osc.io');
var socket = io.connect('http://localhost'),
 osc_socket = osc.connect(io); */

var jsonFile  = require(__dirname + '/jsonfiles/data.json');

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
  res.write(JSON.stringify(jsonFile));
  res.end();
}).listen(1337, '127.0.0.1');

//var osc_client = new osc.UdpSender('192.168.10.10', 9999);
//osc_client.send('/key4', 'f', [2.0]);

console.log('Server running at http://127.0.0.1:1337/');
//console.log('Require:', jsonFile);

