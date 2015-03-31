import haxe.Json;
import models.Connection;
import models.Control;
import models.sensors.Sensor;
import osc.OscMessage;

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

class UdpListenerThread {

    public var listenerThread:Thread;

    private var server:UdpServer;
    private var sensors:Array<Sensor>;

    public function new(server:UdpServer, ?sensors:Array<Sensor>) {
        this.server = server;
        this.sensors = sensors;
        listenerThread = Thread.create(listen);
    }

    private function listen() {
        var lastReceivedMessageTime:Float = Sys.cpuTime();

        while(true) {
            var exitMessage:Dynamic = Thread.readMessage(false);
            if(exitMessage != null && exitMessage == true) {
                break;
            }
            else {
                var receivedMessage:OscMessage = server.receive();
                if(receivedMessage != null) {
                    handleOscMessage(receivedMessage);
                    lastReceivedMessageTime = Sys.cpuTime();
                }
                // If we haven't received a message for 1 second sleep the thread
                else if(Sys.cpuTime() - lastReceivedMessageTime > 1.0) {
                    Sys.sleep(1.0);
                }
            }
        }
    }

    private function handleOscMessage(message:OscMessage) {
        if(message.addressPattern == "/sensors") {
            handleSensorOscMessage(message); 
        }
    }

    private function handleSensorOscMessage(message:OscMessage) {
        var argumentPosition:Int = 0;
        for(sensor in sensors) {
            for(component in sensor.components) {
                if(argumentPosition < message.arguments.length) {
                    component.value = message.arguments[argumentPosition++];
                }
            }
        }
    }

}