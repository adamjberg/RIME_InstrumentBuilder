package;

import msignal.Signal.Signal1;
import openfl.display.Sprite;
import openfl.events.Event;

import hxudp.UdpSocket;
import haxe.io.Bytes;
import haxe.io.BytesInput;

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

import Sys;

import osc.OscMessage;

class UdpServer {

    private static inline var BUFF_SIZE:Int = 65535;
    private static inline var BIND_PORT:Int = 12000;

    public var onOSCMessageReceived:Signal1<OscMessage> = new Signal1<OscMessage>();

    private var listenerThread:Thread;
    private var socket:UdpSocket;

    public function listener() {
        var mainThread:Thread = Thread.readMessage(true);
        var socket:UdpSocket = Thread.readMessage(true);
        socket.setTimeoutReceive(1);
        while(true) {
            var b = Bytes.alloc(BUFF_SIZE);
            var ret:Int = socket.receive(b);
            if(ret > 0)
            {
                var responseMessage:OscMessage = OscMessage.fromBytes(b);
                mainThread.sendMessage(responseMessage);
            }
        }
    }

    public function new (ipAddress, portNumber) {
        socket = new UdpSocket();
        if(socket.create() == false || socket.bind(BIND_PORT) == false)
        {
            trace("Failed To Create Socket");
        }
        trace("connecting to " + ipAddress, portNumber);
        socket.connect(ipAddress, portNumber);
        var msg = new OscMessage("hello");
        socket.send(msg.getBytes());
        listenerThread = Thread.create(listener);
        listenerThread.sendMessage(Thread.current());
        listenerThread.sendMessage(socket);
    }

    public function update() {
        var message:OscMessage = Thread.readMessage(false);
        if(message != null) {
            onOSCMessageReceived.dispatch(message);
        }
    }
}