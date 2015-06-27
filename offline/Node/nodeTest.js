var http = require('http');
var jsonObj  = require("/Users/KV/Dev/projects/DarkMatter/offline/jsonfiles/data.json");
http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end( JSON.stringify(jsonObj));
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');
