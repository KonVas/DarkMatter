var http = require('http'),
    socketio = require('socket.io'),
    server = http.createServer(),
    io = socketio.listen(server),
    osc = require('osc.io');

osc(io);
server.listen(80);

var oscServer = io.connect('http://localhost/osc/servers/8000'),
    oscClient = io.connect('http://localhost/osc/clients/8000');

server.on('message', function(message){
    console.log(message);
});

setInterval( function(){
    oscClient.emit('message', ['/osc/test', 200]);
}, 1000);

////////////////////////
