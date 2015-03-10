package views.sidebar.components;

import haxe.ui.toolkit.controls.Button;
import models.Connection;
import views.controls.LabelledTextInput;
import views.sidebar.components.SidebarComponent;

class ConnectionSetupComponent extends SidebarComponent {

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
    }
}