package;

import models.Connection;
import msignal.Signal.Signal1;

import hxudp.UdpSocket;
import haxe.io.Bytes;

import osc.OscMessage;

class UdpServer {

    private static inline var BUFF_SIZE:Int = 65535;
    private static inline var BIND_PORT:Int = 12000;

    public var onOSCMessageReceived:Signal1<OscMessage> = new Signal1<OscMessage>();

    private var socket:UdpSocket;

    public function new (ipAddress, portNumber) {
        socket = new UdpSocket();
        if(socket.create() == false || socket.bind(BIND_PORT) == false)
        {
            trace("Failed To Create Socket");
        }
        socket.setNonBlocking(true);
    }

    public function connect(connection:Connection) {
        socket.connect(connection.ipAddress, connection.port);
    }

    public function send(message:OscMessage) {
        socket.send(message.getBytes());
    }

    public function update() {
        var b = Bytes.alloc(BUFF_SIZE);
        var ret:Int = socket.receive(b);
        if(ret > 0)
        {
            trace("RECEIVED");
            var message:OscMessage = OscMessage.fromBytes(b);
            if(message != null) {
                onOSCMessageReceived.dispatch(message);
            } else {
                trace("Message is null");
            }
        }
    }
}