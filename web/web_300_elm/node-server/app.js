const WebSocket = require('ws');
const sha = require('sha256');
const port = 1337;
const salt = 'sdl4Df4(dsk!3sk*3saKha13SHA@fsl#';
const FLAG = '#Real70u4r38357Hunter';
const wss = new WebSocket.Server({ port: port });
const pingClient = 100;
const stoneToWin = 1000;

const clientW = 590;
const clientH = 390;

function random(max) {
    return Math.random() * (max) + 5;
}

function getWsId(ws) {
    return ws.id;
}

var PLAYERS = [];

wss.on('connection', function (ws) {
    var id = Math.random();
    PLAYERS[id] = {'x':100, 'y':100};
    console.log("Connected... " + id);

    ws.on('message', function (data) {
        data = JSON.parse(data);
        if (!data['m']) return;

        if (data['m'] == 'move') {
            if (!data['x'] || !data['y']) return;

            PLAYERS[id] = {'x':parseFloat(data['x']), 'y':parseFloat(data['y'])};
        }

        if (data['m'] == 'star_eat') {
            if (!data['s'] || !data['t'] || !data['hash']) return;

            if (sha(data['m'] + data['s'] + data['t'] + salt) !== data['hash']) {
                delete PLAYERS[id];
                ws.send(JSON.stringify({'m' : 'win', 'flag': 'A U HACKEEEER ?????'}));
                return;
            }

            if (data['s'] >= stoneToWin) {
                delete PLAYERS[id];
                ws.send(JSON.stringify({'m' : 'win', 'flag': FLAG}));
                return;
            }
            var newStar = {'m' : 'new_star', 'x': random(clientW), 'y':random(clientH)};
            wss.clients.forEach(function each(client) {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(JSON.stringify(newStar));
                }
            });
        }

    });

    ws.on('close', function (data) {
        delete PLAYERS[id];
    });

    setInterval(function timeout() {
        var clients = [];
        Object.keys(PLAYERS).map(function (k) {
            if (k==id) {
                return;
            }
            clients.push(PLAYERS[k]);
        });
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify({'m':"players", "coords":clients}));
        }
    }, pingClient);

});

console.log('Server started on port:' + port);