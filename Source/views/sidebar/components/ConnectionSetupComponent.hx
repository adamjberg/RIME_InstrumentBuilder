package views.sidebar.components;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import models.Connection;
import msignal.Signal.Signal1;
import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class ConnectionSetupComponent extends SidebarComponent {

    public var onConnectPressed:Signal1<Connection> = new Signal1<Connection>();

    private var connection:Connection;

    private var ip:LabelledTextInput;
    private var port:LabelledTextInput;
    private var connectButton:Button;

    public function new(?title:String, ?connection:Connection) {
        super(title);

        this.connection = connection;

        ip = new LabelledTextInput("ip:");
        ip.setText(connection.ipAddress);
        addChild(ip);

        port = new LabelledTextInput("port:");
        port.setText(Std.string(connection.port));
        addChild(port);

        connectButton = new Button();
        connectButton.toggle = true;
        connectButton.text = "Connect";
        connectButton.horizontalAlign = "center";
        addChild(connectButton);

        connectButton.onClick = function(e:UIEvent) {
            onConnectPressed.dispatch(connection);
        }

        ip.addEventListener(UIEvent.CHANGE, update);
        port.addEventListener(UIEvent.CHANGE, update);
    }

    public function update(e:UIEvent) {
        connection.ipAddress = ip.getText();
        var portNumber:Dynamic = Std.parseInt(port.getText());
        if(portNumber != null) {
            connection.port = portNumber;
        }
    }
}