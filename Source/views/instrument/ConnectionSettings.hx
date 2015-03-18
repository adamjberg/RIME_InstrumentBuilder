package views.instrument;

import haxe.ui.toolkit.containers.VBox;
import models.Connection;
import views.controls.LabelledTextInput;

class ConnectionSettings extends VBox {

    public var ipInput:LabelledTextInput;
    public var portInput:LabelledTextInput;

    public function new(?connection:Connection) {
        super();

        trace(connection);

        percentWidth = 100;

        ipInput = new LabelledTextInput("IP:");
        ipInput.setText(connection.ipAddress);
        ipInput.percentWidth = 100;
        addChild(ipInput);

        portInput = new LabelledTextInput("Port:");
        portInput.setText(Std.string(connection.port));
        portInput.percentWidth = 100;
        addChild(portInput);
    }    

}