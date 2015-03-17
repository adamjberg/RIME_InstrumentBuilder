package;

import models.Connection;

import hxudp.UdpSocket;
import haxe.io.Bytes;

import osc.OscMessage;

class UdpServer {
    private static inline var BUFF_SIZE:Int = 65535;

    private var socket:UdpSocket;

    public function new (bindPort) {
#if !neko
        socket = new UdpSocket();
        if(socket.create() == false || socket.bind(bindPort) == false)
        {
            trace("Failed To Create Socket");
        }
        socket.setNonBlocking(true);
#else
        trace("Not Supported on this Platform");
#end
    }

    public function sendTo(message:OscMessage, connection:Connection) {
#if !neko
        connect(connection);
        send(message);
#else
        trace("Not Supported on this Platform");
#end
    }

    public function receive():OscMessage {
#if !neko
        var b = Bytes.alloc(BUFF_SIZE);
        var ret:Int = socket.receive(b);
        if(ret > 0)
        {
            var message:OscMessage = OscMessage.fromBytes(b);
                return message;
        }
#end
        return null;
    }

    private function connect(connection:Connection) {
        socket.connect(connection.ipAddress, connection.port);
    }

    private function send(message:OscMessage) {
        socket.send(message.getBytes());
    }
}