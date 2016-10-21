var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

var jsonFile = require(__dirname + '/data.json');

const PORT = 4000;

io.on('connection', function(socket){
    socket.emit('alert', 'hello from server');
});

app.get('/', function(req, res){
    res.send(jsonFile);
});

app.listen(PORT, function() {
    console.log('app listening on http://localhost:%s', PORT);
});
