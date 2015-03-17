import models.Connection;
import models.Control;
import osc.OscMessage;

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

class UdpListenerThread {

    public var listenerThread:Thread;

    public function new(server:UdpServer, controlsMap:Map<String, Control>, serverConnection:Connection) {
        listenerThread = Thread.create(listen);
        listenerThread.sendMessage(server);
        listenerThread.sendMessage(controlsMap);
        listenerThread.sendMessage(serverConnection);
    }

    private function listen() {
        var server:UdpServer = Thread.readMessage(true);
        var controlsMap:Map<String, Control> = Thread.readMessage(true);
        var serverConnection:Connection = Thread.readMessage(true);
        var lastReceivedMessageTime:Float = Sys.cpuTime();

        while(true) {
            var exitMessage:Dynamic = Thread.readMessage(false);
            if(exitMessage != null && exitMessage == true) {
                break;
            }
            else {
                var receivedMessage:OscMessage = server.receive();
                if(receivedMessage != null) {
                    var control:Control = controlsMap[receivedMessage.addressPattern];
                    if(control != null) {
                        for(command in control.commands) {
                            var messageToSend:OscMessage = new OscMessage(command.addressPattern);
                            var commandValue:Dynamic = command.values[0];
                            var valueString = Std.string(commandValue);
                            if(controlsMap.exists(valueString)) {
                                // TODO: XY Pad will have 2 values
                                var controlValue:Float = receivedMessage.arguments[0];
                                controlsMap.get(valueString).values[0] = controlValue;
                                messageToSend.addFloat(controlValue);
                            } else if(Std.is(commandValue, String)){
                                messageToSend.addString(commandValue);
                            } else {
                                messageToSend.addFloat(commandValue);
                            }
                            server.sendTo(messageToSend, serverConnection);
                        }
                    }
                    lastReceivedMessageTime = Sys.cpuTime();
                }
                // If we haven't received a message for 1 second sleep the thread
                else if(Sys.cpuTime() - lastReceivedMessageTime > 1.0) {
                    Sys.sleep(1.0);
                }
            }
        }
    }

}