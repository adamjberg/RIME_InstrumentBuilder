package;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import models.Connection;
import models.ControlProperties;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import osc.OscMessage;
import views.instrument.ConnectionSettings;
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

        serverConnection = new Connection("206.87.115.168", 12000);
        server = new UdpServer(11000);

        headerBar = new HeaderBar();
        headerBar.onConnectionSettingsButtonPressed.add(openConnectionSettings);
        addChild(headerBar);

        instrument = new Instrument();
        addChild(instrument);

        listenerThread = new UdpListenerThread(server);

        var timer = new Timer(1000);
        timer.addEventListener(TimerEvent.TIMER, testSendOsc);
        timer.start();

        addEventListener(Event.ENTER_FRAME, enterFrame);
    }

    private function enterFrame(e:Event) {
        var messageFromListenerThread:Dynamic = Thread.readMessage(false);
        if(messageFromListenerThread != null) {
            removeChild(instrument);
            instrument = new Instrument();

            var controls:Array<Dynamic> = messageFromListenerThread;
            for(controlProp in controls) {
                instrument.addControlFromProperties(ControlProperties.fromDynamic(controlProp));
            }

            addChild(instrument);
        }
    }

    private function testSendOsc(e:TimerEvent) {
        var message:OscMessage = new OscMessage("/sensors");
        for(i in 0...23) {
            message.addFloat(Math.random());
        }
        server.sendTo(message, serverConnection);
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