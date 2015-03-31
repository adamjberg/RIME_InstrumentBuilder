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
    private var controls:Array<Control>;
    private var sensors:Array<Sensor>;
    private var uiThread:Thread;

    public function new(server:UdpServer, ?controls:Array<Control>, ?sensors:Array<Sensor>) {
        this.server = server;
        this.controls = controls;
        this.sensors = sensors;
        uiThread = Thread.current();
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
        } else if(message.addressPattern == "/sync") {
            handleSyncMessage(message);
        } else {
            handleControlOscMessage(message);
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

    private function handleSyncMessage(message:OscMessage) {
        var controlsObj:Array<Dynamic> = Json.parse(message.arguments[0]);
        uiThread.sendMessage(controlsObj);
    }

    private function getControlForAddressPattern(addressPattern:String) {
        for(control in controls) {
            if(control.properties.addressPattern == addressPattern) {
                return control;
            }
        }
        return null;
    }

    private function handleControlOscMessage(receivedMessage:OscMessage) {
        
    }

}