package;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import models.Connection;
import models.Control;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import org.haxe.extension.Sensors;
import osc.OscMessage;
import views.instrument.ConnectionSettings;
import views.instrument.controls.IControl;
import views.instrument.HeaderBar;
import views.instrument.Instrument;

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

class MobileApp extends VBox {

    private var serverConnection:Connection;
    private var server:UdpServer;
    private var listenerThread:UdpListenerThread;

    private var headerBar:HeaderBar;
    private var instrument:Instrument;

    public function new() {
        super();

        percentWidth = 100;
        percentHeight = 100;

        serverConnection = new Connection("127.0.0.1", 12000);
        server = new UdpServer(11000);

        headerBar = new HeaderBar();
        headerBar.onConnectionSettingsButtonPressed.add(openConnectionSettings);
        addChild(headerBar);

        instrument = new Instrument();
        addChild(instrument);

        var props:Control = new Control();
        props.addressPattern = "/button1";
        props.type = models.Control.TYPE_PUSHBUTTON;
        instrument.addControlFromProperties(props);

        props = new Control();
        props.addressPattern = "/button2";
        props.type = models.Control.TYPE_TOGGLE;
        props.x = 100;
        instrument.addControlFromProperties(props);

        props = new Control();
        props.addressPattern = "/button3";
        props.type = models.Control.TYPE_HSLIDER;
        props.x = 200;
        instrument.addControlFromProperties(props);

        props = new Control();
        props.addressPattern = "/button4";
        props.type = models.Control.TYPE_VSLIDER;
        props.x = 300;
        instrument.addControlFromProperties(props);

        instrument.onControlValueChanged.add(sendControlValue);

        listenerThread = new UdpListenerThread(server);

        addEventListener(Event.ENTER_FRAME, enterFrame);
    }

    private function enterFrame(e:Event) {
        var messageFromListenerThread:Dynamic = Thread.readMessage(false);
        if(messageFromListenerThread != null) {
            removeChild(instrument);
            instrument = new Instrument();

            var controls:Array<Dynamic> = messageFromListenerThread;
            for(controlProp in controls) {
                instrument.addControlFromProperties(Control.fromDynamic(controlProp));
            }

            addChild(instrument);
        }
        
        var sensorsMessage = new OscMessage("/sensors");
        var sensorArrays:Array<Array<Float>> = new Array<Array<Float>>();
        var linAccel:Array<Float> = Sensors.getLnaccel();
        var accel:Array<Float> = Sensors.getAccel();
        var orientation:Array<Float> = Sensors.getOrient();
        var gyro:Array<Float> = Sensors.getGyro();
        var gravity:Array<Float> = Sensors.getGravity();
        var rotation:Array<Float> = Sensors.getRotvect();
        
        sensorArrays.push(linAccel);
        sensorArrays.push(accel);
        sensorArrays.push(orientation);
        sensorArrays.push(gyro);
        sensorArrays.push(gravity);
        sensorArrays.push(rotation);

        for(sensorArray in sensorArrays) {
            for(val in sensorArray) {
                sensorsMessage.addFloat(val);
            }
        }
        sendMessage(sensorsMessage);
    }

    private function sendControlValue(control:IControl) {
        var properties:Control = control.properties;
        var message:OscMessage = new OscMessage(properties.addressPattern);
        message.addFloat(control.getValue());
        sendMessage(message);
    }

    private function sendMessage(msg:OscMessage) {
        server.sendTo(msg, serverConnection);
    }

    private function openConnectionSettings() {
        var connectionSettingsPopupContent:ConnectionSettings = new ConnectionSettings(serverConnection);
        PopupManager.instance.showCustom(
            connectionSettingsPopupContent,
            "Connection Settings",
            null,
            function(item:Dynamic) {
                serverConnection.ipAddress = connectionSettingsPopupContent.ipInput.getText();
                serverConnection.port = Std.parseInt(connectionSettingsPopupContent.portInput.getText());
            }
        );
    }
}