var http = require('http');
var jsonFile  = require(__dirname + '/jsonfiles/data.json');

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
  res.write(JSON.stringify(jsonFile));
  res.end();
}).listen(1337, '127.0.0.1');

console.log('Server running at http://127.0.0.1:1337/');
//console.log('Require:', jsonFile);
