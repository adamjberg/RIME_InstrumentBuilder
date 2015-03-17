package;

import models.Connection;
import msignal.Signal.Signal1;

import hxudp.UdpSocket;
import haxe.io.Bytes;

import osc.OscMessage;

class UdpServer {
    private static inline var BUFF_SIZE:Int = 65535;

    public var onOSCMessageReceived:Signal1<OscMessage> = new Signal1<OscMessage>();

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

    private function connect(connection:Connection) {
        socket.connect(connection.ipAddress, connection.port);
    }

    private function send(message:OscMessage) {
        socket.send(message.getBytes());
    }

    public function update() {
#if !neko
        var b = Bytes.alloc(BUFF_SIZE);
        var ret:Int = socket.receive(b);
        if(ret > 0)
        {
            trace("RECEIVED");
            var message:OscMessage = OscMessage.fromBytes(b);
            if(message != null) {
                onOSCMessageReceived.dispatch(message);
            }
        }
#end
    }
}