package;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import models.Connection;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import osc.OscMessage;
import views.instrument.ConnectionSettings;
import views.instrument.HeaderBar;
import views.instrument.Instrument;

class MobileApp extends VBox {

    private var serverConnection:Connection;
    private var server:UdpServer;

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

        var timer = new Timer(1000);
        timer.addEventListener(TimerEvent.TIMER, testSendOsc);
        timer.start();
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